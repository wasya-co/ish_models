
RSpec::describe Wco::LeadsController do
  render_views
  routes { Wco::Engine.routes }

  before do
    destroy_every( Wco::Lead, Wco::Leadset, Wco::Tag )
    @tag  = create( :tag )
    @lead = create( :lead, tag_ids: [ @tag.id ] )

    setup_users
  end

  it '#create' do
    n = Wco::Lead.all.length
    post :create, params: { lead: {
      email: 'some@email.com',
      name: 'some name',
    } }
    Wco::Lead.all.length.should eql( n + 1 )
  end

  it '#edit' do
    get :edit, params: { id: @lead.id }
    response.code.should eql '200'
  end

  describe '#index' do
    it 'search' do
      @z_lead_1 = create(:lead, email: 'z@z.com' )
      get :index, params: { q: 'z' }
      response.should redirect_to( lead_path(@z_lead_1.id) )

      @z_lead_2 = create(:lead, email: 'z_2@z.com' )

      get :index, params: { q: 'z' }

      outs = assigns(:leads)
      outs.length.should > 0
      outs.each do |out|
        out.email.include?( 'z' ).should eql true
      end
    end
  end

  it '#new' do
    get :new
    response.code.should eql '200'
  end

  it '#show' do
    get :show, params: { id: @lead.id }
    response.code.should eql '200'
  end

  it '#update' do
    @z = create(:lead,
      email:  'z@z.com',
    )
    patch :update, params: { id: @z.id, lead: {
      email: 'a@a.com',
      tag_ids: [ '' ],
    } }
    Wco::Lead.find( @z.id ).email.should eql 'a@a.com'
  end

end


