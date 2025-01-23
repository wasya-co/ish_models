
RSpec::describe Wco::TagsController do
  render_views
  routes { Wco::Engine.routes }

  before do
    setup_users

    destroy_every(
      Wco::Tag,
      WcoEmail::MessageStub,
    )
    @tag = create( :tag )
  end

  it '#create' do
    expect {
      post :create, params: { tag: { slug: 'some-slug' } }
    }.to change {
      Wco::Tag.all.count
    }.by 1
  end

  it '#index' do
    get :index
    response.code.should eql '200'
    assigns(:tags).length.should > 0
  end



end

