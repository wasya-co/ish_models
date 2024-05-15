

namespace :migrate do

  ## 2024-05-15 Done.
  # desc 'obf to->to_link'
  # task :obf_to_to_link => :environment do
  #   Wco::ObfuscatedRedirect.all.map do |obf|
  #     if !obf[:to_link] && obf[:to]
  #       obf[:to_link] = obf[:to]
  #       if obf.save
  #         print '^'
  #       else
  #         puts obf.errors.full_messages
  #       end
  #     end
  #   end
  #   puts 'ok'
  # end

end
