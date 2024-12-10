
class WcoEmail::EmailFilterAction
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in collection: 'email_filter_actions'

  belongs_to :email_filter

  # field :action_exe ## @deprecated, use :value
  field :value # the id of a tag, or email template, or email action

  KIND_EXE     = 'kind-exe'
  # KIND_RM_TAG  = 'kind-rm-tag'
  # KIND_ADD_TAG = 'kind-add-tag'
  # KIND_AUTORESPOND = 'kind-autorespond'
  # KIND_SCHEDULE_ACTION = 'kind-schedule-action'
  field :kind

end
