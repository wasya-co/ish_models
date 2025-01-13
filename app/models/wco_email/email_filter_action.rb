
class WcoEmail::EmailFilterAction
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in collection: 'email_filter_actions'

  belongs_to :email_filter

  # field :action_exe ## @deprecated, use :value
  field :value # the id of a tag, or email template, or email action

  KIND_EXE         = 'exe'
  KIND_REMOVE_TAG  = 'remove-tag'
  KIND_ADD_TAG     = 'add-tag'
  KIND_AUTORESPOND = 'autorespond-template'
  KIND_SCHEDULE_EMAIL_ACTION = 'autorespond-email-action'
  KIND_REMOVE_EMAIL_ACTION   = 'remove-email-action'
  field :kind

  def to_s
    "kind:#{kind} :: value:#{value}"
  end
end
