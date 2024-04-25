
class Wco::SitemapPath
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  store_in collection: 'wco_sitemap_paths'

  belongs_to :site, class_name: 'Wco::Site'

  field :path,        type: String
  validates :path, presence: true, uniqueness: { scope: :site }

  field :redirect_to, type: String
  field :selector,    type: String
  field :selectors,   type: Array, default: []

  field :status,      type: String

end

