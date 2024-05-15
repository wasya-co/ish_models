
class Wco::Api::ObfuscatedRedirectsController < Wco::ApiController

  def show
    @obf = Wco::ObfuscatedRedirect.find params[:id]
    # puts! @obf, '@obf'
    authorize! :show, @obf

    visit_time = Time.now
    @obf.update_attributes({
      visited_at: visit_time,
      visits:    @obf.visits + [ visit_time ],
    })

    if DEBUG
      render and return
    end

    redirect_to @obf.to
  end

end


