
RSpec.describe WcoEmail::EmailFilterAction, type: :model do

  before do
    destroy_every(
      WcoEmail::EmailFilter,
      WcoEmail::EmailFilterAction,
    )
    @email_filter = create( :email_filter )
  end

  it 'validates value' do
    f = WcoEmail::EmailFilterAction.create({ email_filter: @email_filter,
      kind: 'autorespond-template',
      value: '@TODO',
    })
    f.persisted?.should eql false
    puts! f.errors.full_messages, 'could not create an EmailFilterAction.'
  end

end


