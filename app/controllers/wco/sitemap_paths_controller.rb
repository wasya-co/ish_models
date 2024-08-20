
class Wco::SitemapPathsController < Wco::ApplicationController

  def check
    @spath = Wco::SitemapPath.find params[:id]
    authorize! :check, @spath
    @spath.check
  end

  def create
    authorize! :create, Wco::SitemapPath
    @spath = Wco::SitemapPath.new params[:spath].permit!
    if @spath.save
      flash_notice 'Success.'
      redirect_to wco.site_path(params[:spath][:site_id])
    else
      flash_alert "Could not save spath: #{@spath.errors.full_messages}"
      render 'new'
    end
  end

  def edit
    @spath = Wco::SitemapPath.find params[:id]
    @site = @spath.site
    authorize! :edit, @spath
  end

  def new
    @site = Wco::Site.find( params[:site_id] )
    @spath = Wco::SitemapPath.new site: @site
    authorize! :new, @spath
  end

  def update
    @spath = Wco::SitemapPath.find params[:id]
    authorize! :update, @spath
    flag = @spath.update params[:spath].permit!
    if flag
      flash_notice 'Success'
      redirect_to site_path(@spath.site)
    else
      flash_alert 'No luck.'
      render action: 'edit'
    end

  end


end

