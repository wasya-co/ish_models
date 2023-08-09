require 'autoinc'

#
# Invoice - for wasya.co
# _vp_ 20171031
#
class Ish::Invoice
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Autoinc

  store_in collection: 'ish_invoice'

  field :email, :type => String

  field :number, :type => Integer
  increments :number

  field :amount, :type => Integer

  has_many :payments, :class_name => 'Ish::Payment'
  field :paid_amount, :type => Integer, :default => 0

  field :description, :type => String

  field :items, type: Array

end
