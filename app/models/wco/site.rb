
class Wco::Site
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  store_in collection: 'wco_sites'

  KIND_DRUPAL = 'drupal'
  KIND_IG     = 'instagram'
  KIND_WP     = 'wordpress'
  KINDS       = %w| drupal instagram wordpress |
  field :kind, type: :string
  def self.kinds_list
    [nil] + KINDS
  end

  has_many :publishers # , class_name: 'Wco::Publisher'
  has_many :headlines # , class_name: 'Wco::Newstitle'
  has_many :tags, class_name: 'Wco::Tag'

  field :slug
  validates :slug, presence: true, uniqueness: true

  field :origin # http://pi.local
  validates :origin, presence: true, uniqueness: true

  field :post_path # /node?_format=hal_json
  field :username
  field :password

  def to_s
    origin
  end

  def self.list
    [[nil,nil]] + all.map { |s| [ s.origin, s.id ] }
  end

  def body
    {
      "_links": {
        "type":{"href":"http://pi.local/rest/type/node/article"}
      },
      "title":[{"value":"Node +++ 123 bac +++" }],
      "body":[{"value": "<b>hello, wor</b>ld!", "format": "full_html" }],
      "type":[{"target_id":"article"}],
      "status": [{"value": 1}],
      "_embedded": {
        "http://pi.local/rest/relation/node/article/field_issue": [
          { "uuid": [{ "value": "56229a95-d675-43e1-99b1-f9e11b5579c5" }] }
        ],
        "http://pi.local/rest/relation/node/article/field_tags": [
          { "uuid": [{ "value": "45646a7d-1a16-42e8-b758-f6e1c8d976f7" }] },
          { "uuid": [{ "value": "834e34e2-05ae-498d-b876-453798872ce1" }] }
        ]
      }

    }
  end

  def do_post
    HTTParty.post( post_url,
      body: JSON.generate( body ),
      headers: { 'Content-Type' => 'application/hal+json' },
      basic_auth: { username: username, password: password },
    )
  end

  def wp_import
    site = self

    root_tag = Wco::Tag.find_or_create_by slug: "#{site.slug}_wp-import", site_id: site.id
    url      = "#{site.origin}/wp-json/wp/v2/posts"
    pi_admin = Wco::Profile.find_or_create_by email: 'admin@piousbox.com'
    n_pages  = 12
    per_page = 100

    (1..n_pages).each do |page|
      print "Page #{page}"

      posts = HTTParty.get url, query: { per_page: per_page, page: page }
      posts.each do |post|
        report = Wco::Report.new({
          legacy_id: post['id'],
          created_at: post['date'],
          slug: post['link'].sub(site.origin, ''),
          title: post['title']['rendered'],
          subtitle: post['excerpt']['rendered'],
          body: post['content']['rendered'],
          author: pi_admin,
          tag_ids: ( [ root_tag ] + site.tags.where( :legacy_id.in => post['categories'] ) ).map(&:id),
        })

        if report.save
          print '^'
        else
          puts report.errors.messages
        end
      end
    end
    puts "ok"
  end

end
