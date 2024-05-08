
RSpec::describe Wco::InvoicesController do
  render_views
  routes { Wco::Engine.routes }

  before do
    destroy_every( Wco::Invoice, Wco::Leadset, Wco::Price, Wco::Product )
    setup_users
    @leadset = create(:leadset)
    @product = create(:product)
  end

  it '#edit' do
    @invoice = create( :invoice, leadset: @leadset )
    get :edit, params: { id: @invoice.id }
    response.code.should eql '200'
  end

  it '#new_stripe' do
    get :new_stripe, params: { leadset_id: @leadset.id }
    response.code.should eql '200'
  end

  it '#create_stripe' do
    n_invoices = Wco::Invoice.all.length
    post :create_stripe, params: { invoice: {
      leadset_id: @leadset.id,
      is_stripe: true,
      items: [
        { price_id: @product.prices[0].id, quantity: 1 }
      ],
    } }
    Wco::Invoice.all.length.should eql( n_invoices + 1 )
    result = Wco::Invoice.all.last
    stripe_invoice = Stripe::Invoice.retrieve result.invoice_id
    # puts! stripe_invoice, 'stripe_invoice'
    stripe_invoice.total.should eql 124
    stripe_invoice.status.should eql 'open'
  end

end


