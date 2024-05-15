
class Wco::ObfuscatedRedirectsController < Wco::ApplicationController

  def create
    @obf = Wco::Obf.new params[:obf].permit!
    authorize! :create, @obf

    if @obf.save
      flash_notice 'ok'
    else
      flash_alert @obf
    end
    redirect_to action: :index
  end

  def edit
    @obf = Wco::Obf.find params[:id]
    authorize! :edit, @obf
  end

  def index
    @obfs = Wco::ObfuscatedRedirect.all
    authorize! :index, Wco::ObfuscatedRedirect
  end

  def new
    authorize! :new, @new_obf
  end

  def update
    @obf = Wco::Obf.find params[:id]
    authorize! :create, @obf

    if @obf.update params[:obf].permit!
      flash_notice 'ok'
    else
      flash_alert @obf
    end
    redirect_to action: :index
  end

  ##
  ## private
  ##
  private

  def set_lists
    super
    @new_obf = Wco::ObfuscatedRedirect.new
  end

end

