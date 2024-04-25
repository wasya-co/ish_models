
Wco::Engine.routes.draw do
  root to: 'application#home'

  namespace :api do
    get 'leads/index_hash', to: 'leads#index_hash'
  end

  get 'application/tinymce', to: 'application#tinymce'

  resources :assets
  # get 'assets/:id', to: 'assets#show', as: :asset

  post 'galleries/update', to: 'galleries#update_many', as: :update_galleries
  resources :galleries do
    post 'multiadd', :to => 'photos#j_create', :as => :multiadd
  end

  resources :headlines

  post 'invoices/send/:id',         to: 'invoices#email_send',         as: :send_invoice
  post 'invoices/cr-m/:leadset_id', to: 'invoices#create_monthly_pdf', as: :create_monthly_invoice_for_leadset
  post 'invoices/create-pdf',       to: 'invoices#create_pdf',         as: :create_invoice_pdf
  post 'invoices/create-stripe',    to: 'invoices#create_stripe',      as: :create_invoice_stripe
  get  'invoices/new_pdf',          to: 'invoices#new_pdf',            as: :new_invoice_pdf
  get  'invoices/new_stripe',       to: 'invoices#new_stripe',         as: :new_invoice_stripe
  post 'invoices/:id/send-stripe',  to: 'invoices#send_stripe',        as: :send_invoice_stripe
  resources :invoices

  get  'leads/new',    to: 'leads#new'
  post 'leads/bulkop', to: 'leads#bulkop'
  post 'leads/import', to: 'leads#import', as: :leads_import
  get  'leads/:id',    to: 'leads#show', id: /[^\/]+/
  resources :leads
  resources :leadsets
  delete 'logs/bulkop', to: 'logs#bulkop', as: :logs_bulkop
  resources :logs

  post 'office_action_templates', to: 'office_action_templates#update'
  resources :office_action_templates
  resources :office_actions

  resources :prices
  resources :products
  resources :profiles
  post 'publishers/:id/do-run', to: 'publishers#do_run', as: :run_publisher
  resources :publishers

  post   'photos/update-ordering', to: 'galleries#update_ordering', as: :update_ordering_photos
  post   'photos/move',   to: 'photos#move',    as: :move_photos
  delete 'photos/delete', to: 'photos#destroy', as: :delete_photos
  resources :photos

  get 'reports/deleted', to: 'reports#index', as: :deleted_reports, defaults: { deleted: true }
  resources :reports

  post 'sites/:id/check_sitemap', to: 'sites#check_sitemap', as: :check_sitemap
  resources :sites
  resources :sitemap_paths
  resources :subscriptions

  delete 'tags/remove/:id/from/:resource/:resource_id', to: 'tags#remove_from', as: :remove_tag_from
  post   'tags/add-to/:resource/:resource_id', to: 'tags#add_to', as: :add_tag_to
  resources :tags

  ## In order to have unsubscribes_url , unsubscribes must be in wco .
  get 'unsubscribes/analytics', to: 'unsubscribes#analytics'
  resources :unsubscribes

  resources :videos

end
