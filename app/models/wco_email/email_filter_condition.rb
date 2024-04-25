
class WcoEmail::EmailFilterCondition
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  store_in collection: 'office_email_filter_conditions'

  belongs_to :email_filter,      inverse_of: :email_filter_conditions
  belongs_to :email_filter_skip, inverse_of: :email_filter_skip_conditions

  field :field
  field :matchtype
  field :value


end

