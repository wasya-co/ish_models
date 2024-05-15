
RSpec::describe Wco::Api::ObfuscatedRedirectsController do
  render_views
  routes { Wco::Engine.routes }

  before do
    setup_users
    destroy_every( Wco::Obf )
    @obf = create( :obf )
  end

  it '#show' do
    get :show, params: { id: @obf.id.to_s }
    response.code.should eql '302'
  end

end

