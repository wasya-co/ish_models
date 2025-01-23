

namespace :db do

  desc 'seed'
  task :seed do
    leadset = Wco::Leadset.find_or_create_by({ company_url: 'poxlovi@gmail.com' })
    leadset.persisted?
    lead    = Wco::Lead.find_or_create_by({ email: 'poxlovi@gmail.com', leadset: leadset })
    lead.persisted?

    blank_email_template = WcoEmail::EmailTemplate.find_or_create_by({ slug: 'blank' })
    blank_email_template.persisted?

    Wco::Tag.inbox
    Wco::Tag.trash
    Wco::Tag.spam
    Wco::Tag.not_spam

  end

end
