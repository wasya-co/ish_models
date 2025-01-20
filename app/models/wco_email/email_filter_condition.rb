
module WcoEmail
  FIELD_BODY    = 'body'
  FIELD_EXE     = 'exe'
  FIELD_FROM    = 'from'
  FIELD_LEADSET = 'leadset'
  FIELD_SUBJECT = 'subject'
  FIELD_TO      = 'to'

  OPERATOR_EQUALS      = 'equals'
  OPERATOR_HAS_TAG     = 'has-tag'
  OPERATOR_NOT_HAS_TAG = 'not-has-tag'
end

class WcoEmail::EmailFilterCondition
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  store_in collection: 'office_email_filter_conditions'

  belongs_to :email_filter,      class_name: '::WcoEmail::EmailFilter', inverse_of: :conditions,      optional: true
  belongs_to :email_skip_filter, class_name: '::WcoEmail::EmailFilter', inverse_of: :skip_conditions, optional: true

  ## see WcoEmail::FIELD_*
  field :field
  validates :field, presence: true

  OPERATOR_EQUALS      = WcoEmail::OPERATOR_EQUALS
  OPERATOR_HAS_TAG     = WcoEmail::OPERATOR_HAS_TAG
  OPERATOR_NOT_HAS_TAG = WcoEmail::OPERATOR_NOT_HAS_TAG
  field :operator, type: String
  validates :operator, presence: true

  field :value
  validates :value, presence: true

  def to_s
    "<EFC #{field} #{operator} #{value} />"
  end
  def to_s_full indent: 0
    _value = value
    if [ OPERATOR_HAS_TAG, OPERATOR_NOT_HAS_TAG ].include?( operator )
      _value = Wco::Tag.find( value )
    end
    "#{" " * indent }<EmailFilterCondition #{field} #{operator} `#{_value}` />\n"
  end
end

=begin

## not whitelisted
tag = Wco::Tag.find_by({ slug: 'known-leadsets' })
out = @company.tags.include?( tag )
!out

=end
