
class WcoEmail::EmailFilterCondition
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  store_in collection: 'office_email_filter_conditions'

  belongs_to :email_filter,      class_name: '::WcoEmail::EmailFilter', inverse_of: :conditions,      optional: true
  belongs_to :email_skip_filter, class_name: '::WcoEmail::EmailFilter', inverse_of: :skip_conditions, optional: true

  FIELD_BODY    = 'body'
  FIELD_EXE     = 'exe'
  FIELD_FROM    = 'from'
  FIELD_LEADSET = 'leadset'
  FIELD_SUBJECT = 'subject'
  FIELD_TO      = 'to'
  field :field

  MATCHTYPE_EQUALS      = 'equals'
  MATCHTYPE_HAS_TAG     = 'has-tag'
  MATCHTYPE_NOT_HAS_TAG = 'not-has-tag'
  field :matchtype

  field :value


end

=begin

## not whitelisted
tag = Wco::Tag.find_by({ slug: 'known-leadsets' })
out = @company.tags.include?( tag )
!out

=end
