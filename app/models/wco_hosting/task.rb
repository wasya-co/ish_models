
class WcoHosting::Task
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  store_in collection: 'wco_tasks'

  belongs_to :task_tmpl,      class_name: 'WcoHosting::TaskTmpl'
  belongs_to :appliance_tmpl, class_name: 'WcoHosting::ApplianceTmpl'

end
