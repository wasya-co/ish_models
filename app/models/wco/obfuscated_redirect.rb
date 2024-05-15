
class Wco::ObfuscatedRedirect
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  store_in collection: 'office_obfuscated_redirects'

  field :slug, type: :string

  field :to_link,     type: :string
  validates :to_link, presence: true

  field :visited_at, type: DateTime
  field :visits, type: :array, default: []

  def obf_link
    "https://email.wasya.co/api/obf/#{self.id}"
  end

end
Wco::Obf ||= Wco::ObfuscatedRedirect
