
require 'distribution'
N = Distribution::Normal

module Iro::OptionBlackScholes

  ##
  ## black-scholes pricing
  ##

=begin
  ##
  ##
  ##
  annual to daily:

  AR = ((DR + 1)^365 – 1) x 100

  ##
  ##
  ##
  From: https://www.investopedia.com/articles/optioninvestor/07/options_beat_market.asp

  K :: strike price
  S_t :: last
  r :: risk-free rate
  t :: time to maturity

  C = S_t N( d1 ) - K e^-rt N( d2 )

  d1 = ln( St / K ) + (r + theta**2 /  2 )t
    /{ theta_s * sqrt( t ) }

  d2 = d1 - theta_s sqrt( t )

  ##
  ## From: https://en.wikipedia.org/wiki/Black%E2%80%93Scholes_model
  ##

  D  ::  e^(rt)    # discount factor
  F  ::  e^(rt) S  # forward price of underlying

  C(F,t) = D[ N(d1)F - N(d2)K ]

  d1 = ln(F/K) + stdev**2 t / 2
    /{ stdev sqrt(t) }
  d2 = d1 - stdev sqrt(t)

  ##
  ## From: https://www.daytrading.com/options-pricing-models
  ##
  C0 = S0N(d1) – Xe-rtN(d2)

  C0 = current call premium
  S0 = current stock price
  N(d1) = the probability that a value in a normal distribution will be less than d
  N(d2) = the probability that the option will be in the money by expiration
  X = strike price of the option
  T = time until expiration (expressed in years)
  r = risk-free interest rate
  e = 2.71828, the base of the natural logarithm
  ln = natural logarithm function
  σ = standard deviation of the stock’s annualized rate of return (compounded continuously)
  d1 = ln(S0/X) + (r + σ2/2)Tσ√T

  d2 = d1 – σ√T

  Note that:

  Xe-rt = X/ert = the present value of the strike price using a continuously compounded interest rate

  ##
  ## From: https://www.wallstreetmojo.com/black-scholes-model/
  ##


  ## init
  require 'distribution'
  N = Distribution::Normal
  stock = Iro::Stock.find_by ticker: 'NVDA'
  strike = 910.0
  r = Iro::Option.rate_daily
  stdev = 91.0
  t = 7.0
  expires_on = '2024-03-22'

=end
  def d1
    last   = stock.last
    r      = self.class.rate_annual

    out = Math.log( last / strike ) + ( r + stdev**2 / 2 ) * t
    out = out /( stdev * Math.sqrt(t) )
    return out
  end
  def d2
    last   = stock.last
    r      = self.class.rate_annual

    out = d1 - stdev * Math.sqrt( t )
    return out
  end
  def t
    # t      = 1.0 / 365 * Date.today.business_days_until( expires_on )
    t      = 1.0 / 365 * (expires_on - Date.today).to_i
  end
  def stdev
    recompute = nil
    stock.stdev( recompute: recompute )
  end
  def call_price
    last   = stock.last
    r      = self.class.rate_annual

    out = N.cdf( d1 ) * last - N.cdf( d2 ) * strike * Math::E**( -1 * r * t )
    return out
  end

  def put_price
    last   = stock.last
    r      = self.class.rate_annual

    out = N.cdf(-d2) * strike * exp(-r*t) - N.cdf(-d1) * last
    return out
  end


  def self.rate_annual
    0.05
  end

=begin
# test

inn = 100
n.times { inn = inn*(1.0+out) }
inn

=end
  def self.rate_daily
    n = 250.0 # days
    # n = 12 # months

    out = (1.0+self.rate_annual)**(1.0/n) - 1.0
    puts! out, 'rate_daily'
    return out
  end

end
