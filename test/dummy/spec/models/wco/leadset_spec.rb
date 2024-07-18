

RSpec.describe Wco::Leadset do

  before do
    Wco::Leadset.unscoped.map &:destroy!
  end

  it 'sanity' do
    m = Wco::Leadset.create( company_url: 'abba.com' )
    m.persisted?.should eql true
  end

  it 'from email' do
    m = Wco::Leadset.from_email( 'abba@some-company.com' )
    m.persisted?.should eql true
    m.domain.should eql 'some-company.com'

    m = Wco::Leadset.from_email( 'abba@h.h.h.some-company.com' )
    m.persisted?.should eql true
    m.domain.should eql 'some-company.com'

    m = Wco::Leadset.from_email( 'abba@some-company.com.co' )
    m.persisted?.should eql true
    m.domain.should eql 'some-company.com.co'

    m = Wco::Leadset.from_email( 'abba@h.h.h.some-company.com.co' )
    m.persisted?.should eql true
    m.domain.should eql 'some-company.com.co'
  end

end


