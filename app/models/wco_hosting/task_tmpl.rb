
class WcoHosting::TaskTmpl
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  store_in collection: 'wco_task_tmpls'

  field :slug
  validates :slug, presence: true

end
