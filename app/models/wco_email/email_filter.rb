
##
## 2023-03-04 _vp_ When I receive one.
##
class WcoEmail::EmailFilter
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  store_in collection: 'office_email_filters' # 'wco_email_email_filters'

  PAGE_PARAM_NAME = :filters_page

  FIELD_OPTS     = [ :subject, :from, :to, :to_and_cc, :body, ]
  MATCHTYPE_OPTS = [ :regex, :exact_insensitive, ]

  field :from_regex
  field :from_exact
  field :subject_regex
  field :subject_exact
  field :body_regex
  field :body_exact

  field :skip_from_regex
  field :skip_to_exact

  has_many :actions, class_name: '::WcoEmail::EmailFilterAction', inverse_of: :email_filter
  accepts_nested_attributes_for :actions

  ## 'and' - all conditions must match, for filter to match
  has_many :conditions,      class_name: '::WcoEmail::EmailFilterCondition', inverse_of: :email_filter
  accepts_nested_attributes_for :conditions

  ## 'and' - all conditions must match, for filter to match
  has_many :skip_conditions, class_name: '::WcoEmail::EmailFilterCondition', inverse_of: :email_skip_filter
  accepts_nested_attributes_for :skip_conditions


  has_and_belongs_to_many :action_tmpls, class_name: '::Wco::OfficeActionTemplate'
  has_and_belongs_to_many :leadsets,     class_name: '::Wco::Leadset'

  belongs_to :tag, class_name: '::Wco::Tag', inverse_of: :email_filters, optional: true

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


  belongs_to :email_template,        class_name: '::WcoEmail::EmailTemplate',         optional: true
  belongs_to :email_action_template, class_name: '::WcoEmail::EmailActionTemplate',   optional: true

  ## @TODO: change to has_and_belongs_to_many, test-driven.
  has_many :conversations, class_name: '::WcoEmail::Conversation', inverse_of: :filter

  def to_s
    "EmailFilter: #{from_regex} #{from_exact} #{conditions.map { |c| c.to_s }.join }"
  end

  def to_xml
    attrs = ''
    children = ''
    if from_regex || from_exact
      attrs = "#{attrs} from=#{from_regex}#{from_exact}"
    end
    if conditions.present?
      children = "#{children}#{conditions.map { |c| c.to_s }.join('') }"
    end
    return "<EF #{attrs}>#{children}</EF>\n"
  end



end

