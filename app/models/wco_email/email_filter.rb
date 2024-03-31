
##
## 2023-03-04 _vp_ When I receive one.
##
class WcoEmail::EmailFilter
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  store_in collection: 'office_email_filters' # 'wco_email_email_filters'

  PAGE_PARAM_NAME = :filters_page

  field :from_regex
  field :from_exact
  field :subject_regex
  field :subject_exact
  field :body_regex
  field :body_exact

  field :skip_from_regex
  field :skip_to_exact

  belongs_to :tag, class_name: 'Wco::Tag', inverse_of: :email_filters, optional: true

  KIND_AUTORESPOND_TMPL = 'autorespond-template'
  KIND_AUTORESPOND_EACT = 'autorespond-email-action'
  KIND_REMOVE_TAG       = 'remove-tag'
  KIND_ADD_TAG          = 'add-tag'
  KIND_DESTROY_SCHS     = 'destroy-schs'

  ## @deprecated
  KIND_AUTORESPOND = 'autorespond' ## @deprecated, DO NOT USE!
  KIND_DELETE      = 'delete'      ## @deprecated, use add-tag
  KIND_SKIP_INBOX  = 'skip-inbox'  ## @deprecated, use remove-tag

  KINDS = [ nil, KIND_AUTORESPOND_TMPL, KIND_AUTORESPOND_EACT, KIND_ADD_TAG, KIND_REMOVE_TAG, KIND_DESTROY_SCHS]
  field :kind

  belongs_to :email_template,        class_name: 'WcoEmail::EmailTemplate',         optional: true
  belongs_to :email_action_template, class_name: 'WcoEmail::EmailActionTemplate',   optional: true

  has_many :conversations, class_name: 'WcoEmail::Conversation', inverse_of: :filter

end

