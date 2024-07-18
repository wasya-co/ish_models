
RSpec.describe WcoEmail::EmailFilter, type: :model do

  before do
    destroy_every(
      WcoEmail::Conversation,
      WcoEmail::EmailFilter,
      Wco::Leadset,
      Wco::Tag,
    )
    # @tag = Wco::Tag.create( slug: 'test-tag' )
  end

  it 'habtm leadsets' do
    f = WcoEmail::EmailFilter.create
    f.persisted?.should eql true

    ls = Wco::Leadset.create company_url: 'wasya.co'
    ls.persisted?.should eql true

    f.leadsets.push ls
    f.save
    f.reload
    ls.reload

    ls.email_filters[0].id.should eql f.id
  end

end


