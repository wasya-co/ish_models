
class Wco::SitemapPath
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  store_in collection: 'wco_sitemap_paths'

  belongs_to :site, class_name: 'Wco::Site'

  field :path,        type: String
  validates :path, presence: true, uniqueness: { scope: :site }

  field :meta_description, type: String
  field :redirect_to, type: String
  field :selector,    type: String
  field :selectors,   type: Array, default: []

  field :results, type: Array, default: []
  field :status,  type: String

  def check
    self.status = 'NOT_OK'
    if self[:selector].present?
      begin
        body = HTTParty.get( "#{site.origin}#{self[:path]}" ).body
      rescue OpenSSL::SSL::SSLError => err
        results.push "NOT OK [ssl-exception] #{self[:path]}".red
        return
      end
      doc = Nokogiri::HTML( body )
      out = doc.search self[:selector]
      if out.present?
        results.push "OK #{self[:path]}"
        self.status = 'OK'
      else
        results.push "NOT OK [selector-missing] #{self[:path]}".red
      end

      if self[:meta_description]
        out = doc.search( 'head meta[name="description"]' )[0]['content']
        if self[:meta_description] == out
          results.push "OK #{self[:path]} meta_description"
          self.status = 'OK'
        else
          results.push "NOT OK [meta-description-missing] #{self[:path]}".red
        end
      end

    elsif self[:redirect_to].present?
      out = HTTParty.get( "#{site.origin}#{self[:path]}", follow_redirects: false )
      if( out.headers[:location] == self[:redirect_to] ||
          out.headers[:location] == "#{site.origin}#{self[:redirect_to]}" )
        results.push "OK #{self[:path]}"
        self.status = 'OK'
      else
        results.push "NOT OK [redirect-missing] #{self[:path]}".red

        puts!( out.response, 'response' ) if DEBUG
        # puts!( out.body, 'body' ) if DEBUG

        puts "NOT OK #{self[:path]}".red
        puts out.headers[:location]
        puts self[:redirect_to]
      end
    else
      results.push "SKIP #{self[:path]}"
      self.status = 'OK'
    end

    if self[:selectors].present?
      self[:selectors].each do |selector|
        body = HTTParty.get( "#{site.origin}#{self[:path]}" ).body
        doc = Nokogiri::HTML( body )
        out = doc.search selector
        if out.present?
          results.push "OK #{self[:path]} selectors:#{selector}"
          self.status = 'OK'
        else
          results.push "NOT OK [selectors-missing:#{selector}] #{self[:path]}".red
        end
      end
    end
    self.save
  end

end

