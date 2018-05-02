require 'date'

module ExchangeRate
  class InvalidCurrency < Exception; end
  class InvalidDate < Exception; end
  class OutOfRangeDate < Exception; end

  INITIAL_BASE_CURRENCY = 'EUR'
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

  class Conversion
    attr_reader :date, :base_value, :conversion_currency

    def initialize(database)
      @database = database
    end

    def date=(value)
      @date = Date.iso8601(value.to_s)
    rescue ArgumentError
      raise InvalidDate
    end

    def base_currency=(value)
      raise InvalidCurrency unless valid_currency?(value)

      @base_value = value
    end

    def conversion_currency=(value)
      raise InvalidCurrency unless valid_currency?(value)

      @conversion_currency = value
    end

    def rate
      return BASE_RATE if @base_value == @conversion_currency

      for_date = @database.fetch(date.to_s, nil)

      raise OutOfRangeDate if for_date.nil?

      rate = for_date.fetch(@conversion_currency, nil)

      raise InvalidCurrency if rate.nil?

      rate
    end

    private
      def valid_currency?(value)
        return true if SUPPORTED_CURRENCIES.include?(value.to_s.upcase)
      end
  end
end
