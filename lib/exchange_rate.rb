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

  class << self
    def at(date, from_currency, to_currency)
      raise InvalidCurrency unless valid_input?(from_currency, to_currency)

      date = Date.iso8601(date)

      return BASE_RATE if from_currency == to_currency

      for_date = all_rates.fetch(date.to_s)

      raise OutOfRangeDate if for_date.nil?

      for_date.fetch(to_currency)
    rescue KeyError => _e
      raise OutOfRangeDate
    rescue ArgumentError => _e
      raise InvalidDate
    end

    def all_rates
      @all_rates ||= Database.all
    end

    private
      def valid_input?(from, to)
        if SUPPORTED_CURRENCIES.include?(from.upcase) &&
          SUPPORTED_CURRENCIES.include?(to.upcase)
            true
        end
      end
  end
end
