
class Wco::LeadsController < Wco::ApplicationController

  before_action :set_lists

  def create
    params[:lead][:tags].delete ''
    params[:lead][:leadset] = nil if params[:lead][:leadset].blank?

    @lead = Wco::Lead.new params[:lead].permit!
    authorize! :create, @lead
    if @lead.save
      flash_notice 'ok'
    else
      flash_alert @lead
    end
    redirect_to action: :index
  end

  def edit
    authorize! :edit, Wco::Lead
    @lead = Wco::Lead.find params[:id]
  end

  def index
    authorize! :index, Wco::Lead
    @leads = Wco::Lead.all

    if params[:q].present?
      @leads = @leads.any_of(
        { email: /#{params[:q].downcase}/i },
        { name:  /#{params[:q].downcase}/i } )
    end

    # if params[:q_tag_ids].present?
    #   carry = nil
    #   params[:q_tag_ids].each do |term_id|
    #     lts = LeadTag.where({ term_id: term_id }).map(&:lead_id)
    #     if carry
    #       carry = carry & lts
    #     else
    #       carry = lts
    #     end
    #   end
    #   @leads = Lead.where({ :id.in => carry })
    # end

    @leads = @leads.page( params[:leads_page ] ).per( current_profile.per_page )
  end

  def new
    authorize! :new, Wco::Lead
    @lead = Wco::Lead.new
  end

  def show
    @lead      = Wco::Lead.where({ id: params[:id] }).first
    @lead    ||= Wco::Lead.where({ email: params[:id] }).first
    authorize! :show, @lead
    if !@lead
      flash_alert "This lead does not exist"
      redirect_to request.referrer
      return
    end
    # @schs      = Sch.where( lead_id: @lead.id )
    # @ctxs      = Ctx.where( lead_id: @lead.id )
    # @convs     = Conv.find( Office::EmailConversationLead.where( lead_id: @lead.id ).map( &:email_conversation_id ) )
    # @msgs      = Msg.where( from: @lead.email )
    # @galleries = @lead.galleries.page( params[:galleries_page] ).per( current_profile.per_page )
    # @videos    = @lead.videos.page( params[:videos_page]       ).per( current_profile.per_page )
  end

  def update
    params[:lead][:tags].delete ''
    params[:lead].delete :leadset if params[:lead][:leadset].blank?

    @lead = Wco::Lead.find params[:id]
    authorize! :update, @lead
    if @lead.update params[:lead].permit!
      flash_notice 'ok'
    else
      puts! @lead.errors.full_messages.join(", "), 'cannot update lead'
      flash_alert @lead
    end
    redirect_to action: :show, id: @lead.id
  end

  ##
  ## private
  ##
  private

  def set_lists
    @email_campaigns_list = [[nil,nil]] + WcoEmail::Campaign.all.map { |c| [ c.slug, c.id ] }
    @leadsets_list        = Wco::Leadset.list
    @tags_list            = Wco::Tag.list
  end


end

