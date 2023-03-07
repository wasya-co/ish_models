
##
## When I receive one.
##
class Office::EmailMessage
  include Mongoid::Document
  include Mongoid::Timestamps

  field :raw,         type: :string

  field :message_id,  type: :string # MESSAGE-ID
  validates_uniqueness_of :message_id
  index({ message_id: 1 }, { unique: true, name: "message_id_idx" })

  field :in_reply_to_id, type: :string

  field :object_key,  type: :string ## aka 'filename', use with bucket name + prefix
  # validates_presence_of :object_key
  field :object_path, type: :string ## A routable s3 url

  field :subject
  field :part_txt
  field :part_html
  # attachments ?

  def lead
    Lead.find_by email: from
  end

  field :from,  type: :string
  field :froms, type: Array, default: []
  field :to,    type: :string
  field :tos,   type: Array, default: []
  field :ccs,   type: Array, default: []
  field :bccs,  type: Array, default: []

  field :date, type: DateTime
  def received_at
    date
  end

  ## Copied to email_conversation
  field :wp_term_ids, type: Array, default: []
  ## Tested manually ok, does not pass the spec. @TODO: hire to make pass spec? _vp_ 2023-03-07
  def add_tag tag
    if WpTag == tag.class
      self[:wp_term_ids] = self[:wp_term_ids].push(tag.id).uniq
      self.save!
    else
      throw "#add_tag expects a WpTag as the only parameter."
    end
  end
  def remove_tag tag
    if WpTag == tag.class
      self[:wp_term_ids].delete( tag.id )
      self.save!
    else
      throw "#remove_tag expects a WpTag as the only parameter."
    end
  end

  belongs_to :email_conversation
  def conv
    email_conversation
  end

  ## @TODO: reimplement, look at footer instead.
  def name
    return 'associate'
    # from[0].split('@')[0].upcase
  end

  def company_url
    from[0].split('@')[1]
  end

  def apply_filter filter
    case filter.kind
    when ::Office::EmailFilter::KIND_SKIP_INBOX
      self.remove_tag( ::WpTag.email_inbox_tag )
    when ::Office::EmailFilter::KIND_AUTORESPOND
      Ish::EmailContext.create({
        email_template: ::Tmpl.find_by_slug( filter.email_template_slug ),
        lead: lead,
      })
    # when 'autorespond-remind'
    #   Office::EmailAction.create({
    #     tmpl_slug: 'require-sign-nda',
    #     next_in_days: -> { rand(1..5) },
    #     next_at_time: ->{ rand(8..16).hours + rand(1..59).minutes },
    #     next_action: 're-remind-sign-nda',
    #   })
    #   Ish::EmailContext.create({
    #     email_template: ::Tmpl.find_by_slug( filter.email_template_slug ),
    #     lead: lead,
    #   })
    else
      raise "unknown filter kind: #{filter.kind}"
    end
  end

end
::Msg = Office::EmailMessage



  ## trash _vp_ 2023-03-07
  # def process
  #   Aws.config[:credentials] = Aws::Credentials.new(
  #     ::S3_CREDENTIALS[:access_key_id],
  #     ::S3_CREDENTIALS[:secret_access_key]
  #   )
  #   s3 = Aws::S3::Client.new
  #   obj = s3.get_object({
  #     bucket: 'ish-ses',
  #     key: self.object_key
  #   })
  #   obj2 = obj.body.read
  #   mail        = Mail.read_from_string( obj2 )
  #   self.from    = mail.from
  #   self.to      = mail.to
  #   self.subject = mail.subject
  #   self.date    = mail.date
  #   self.raw     = obj2
  #   self.save
  # end