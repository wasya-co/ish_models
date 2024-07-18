
class Wco::SitemapPathsController < Wco::ApplicationController

  def edit
    @spath = Wco::SitemapPath.find params[:id]
    authorize! :edit, @spath
  end

  def update
    @spath = Wco::SitemapPath.find params[:id]
    authorize! :update, @spath
    flag = @spath.update params[:sitemap_path].permit!
    if flag
      flash_notice 'Success'
      redirect_to site_path(@spath.site)
    else
      flash_alert 'No luck.'
      render action: 'edit'
    end

  end


end

