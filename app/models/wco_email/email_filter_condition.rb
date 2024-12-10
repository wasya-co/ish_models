
class WcoEmail::EmailFilterCondition
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  store_in collection: 'office_email_filter_conditions'

  belongs_to :email_filter,      class_name: '::WcoEmail::EmailFilter', inverse_of: :conditions,      optional: true
  belongs_to :email_skip_filter, class_name: '::WcoEmail::EmailFilter', inverse_of: :skip_conditions, optional: true

  FIELD_SUBJECT = 'subject'
  ## ...
  FIELD_MATCH_EXE = 'match-exe' ## dynamic flexible condition
  ## field can be: @lead or @lead.company !
  field :field

  ## matchtype can be: not-in-tag
  field :matchtype
  field :value


end

=begin

## not whitelisted
tag = Wco::Tag.find_by({ slug: 'known-leadsets' })
out = @company.tags.include?( tag )
!out

=end
