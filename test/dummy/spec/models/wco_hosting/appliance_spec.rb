
RSpec.describe WcoHosting::Appliance do

  before do
    destroy_every(
      Wco::Leadset,
      WcoHosting::ApplianceTmpl,
      WcoHosting::Serverhost,
    )
    @leadset    = create( :leadset )
    @serverhost = create( :vbox1, leadsets: [ @leadset ] )
    @tmpl       = create( :hw0_tmpl )
    @appliance  = create( :appliance, {
      appliance_tmpl: @tmpl,
      leadset: @leadset,
      serverhost: @serverhost,
    })
  end

end


