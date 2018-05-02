require 'exchange_rate/version'
require 'exchange_rate/database'

module ExchangeRate
  class InvalidDate < Exception; end
  class OutOfRangeDate < Exception; end
  class InvalidCurrency < Exception; end

  BASE_CURRENCY = 'EUR'
  BASE_RATE = 1.0
  SUPPORTED_CURRENCIES = %w[
    AUD
    BGN
    BRL
    CAD
    CHF
    CNY
    CZK
    DKK
    EUR
    GBP
    HKD
    HRK
    HUF
    IDR
    ILS
    INR
    ISK
    JPY
    KRW
    MXN
    MYR
    NOK
    NZD
    PHP
    PLN
    RON
    RUB
    SEK
    SGD
    THB
    TRY
    USD
    ZA
  ]

  def self.at(date, from_currency, to_currency)
    from_currency = from_currency.upcase
    to_currency = to_currency.upcase

    unless SUPPORTED_CURRENCIES.include?(from_currency) &&
      SUPPORTED_CURRENCIES.include?(to_currency)
        raise InvalidCurrency
    end

    date = Date.iso8601(date)

    currencies = Database.all

    return BASE_RATE if from_currency == to_currency

    currencies.fetch(date.to_s).fetch(to_currency)
  rescue KeyError => _e
    raise OutOfRangeDate
  rescue ArgumentError => _e
    raise InvalidDate
  end
end
