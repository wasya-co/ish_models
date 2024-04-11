
namespace :wp do

  desc 'import a whole site into reports'
  task :import_all_reports => :environment do
    site     = Wco::Site.find_by slug: 'pi-drup-prod'
    site.wp_import
  end

end
