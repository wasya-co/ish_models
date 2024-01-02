
module Wco::ApplicationHelper

  def my_truthy? which
    ["1", "t", "T", "true"].include?( which )
  end

  def obfuscate link
    # puts! link, 'obfuscate helper' if DEBUG
    obf = WcoEmail::ObfuscatedRedirect.find_or_create_by({ to: link })
    return WcoEmail::Engine.routes.url_helpers.obf_url( obf.id, {
      host: Rails.application.routes.default_url_options[:host],
    })
  end

  def pretty_date date
    # date.to_s[0, 10]
    date&.strftime('%Y-%m-%d')
  end
  def pp_date a; pretty_date a; end

  def pp_datetime date
    date&.strftime('%Y-%m-%d %l:%M%P %z')
  end

  def pp_time date
    return nil if !date
    # return date.strftime('%l:%M%P %z')
    return date.in_time_zone( Rails.application.config.time_zone ).strftime('%l:%M%P')
  end

  def pp_amount a
    return '-' if !a
    "$ #{'%.2f' % a}"
  end
  def pp_money a; pp_amount a; end
  def pp_currency a; pp_amount a; end
  def pp_percent a
    "#{(a*100).round(2)}%"
  end

end
