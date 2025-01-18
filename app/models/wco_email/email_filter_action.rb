
class WcoEmail::EmailFilterAction
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in collection: 'email_filter_actions'

  belongs_to :email_filter

  KIND_EXE         = 'exe'
  KIND_REMOVE_TAG  = 'remove-tag'
  KIND_ADD_TAG     = 'add-tag'
  KIND_AUTORESPOND = 'autorespond-template'
  KIND_SCHEDULE_EMAIL_ACTION = 'autorespond-email-action'
  KIND_REMOVE_EMAIL_ACTION   = 'remove-email-action'
  field :kind

  # field :action_exe ## @deprecated, use :value
  field :value # the id of a tag, or email template, or email action


  before_validation :check_value
  def check_value
    case kind
    when KIND_AUTORESPOND
      existing = WcoEmail::EmailTemplate.where({ id: value }).first
      if !existing
        errors.add( :base, 'missing EmailTemplate id when creating an EmailFilterAction' )
        throw :abort
      end
    end
  end


  def to_s
    "<EFA #{kind} #{value} />\n"
  end
end
