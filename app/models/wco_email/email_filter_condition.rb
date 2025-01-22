
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

  field :operator, type: String
  validates :operator, presence: true, inclusion: ::WcoEmail::OPERATORS

  field :value
  validates :value, presence: true

  def to_s
    "<EFC #{field} #{operator} #{value} />"
  end
  def to_s_full indent: 0
    _value = value
    if [ ::WcoEmail::OPERATOR_HAS_TAG, ::WcoEmail::OPERATOR_NOT_HAS_TAG ].include?( operator )
      _value = Wco::Tag.find( value )
    end
    "#{" " * indent }<EF#{email_skip_filter ? 'Skip' : ''}Condition #{field} #{operator} `#{_value}` />\n"
  end
end

