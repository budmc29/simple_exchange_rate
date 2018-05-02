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

  class Currency
    attr_reader :date
    attr_accessor :base_value, :convert_to

    def initialize(database)
      @database = database
    end

    def date=(value)
      @date = Date.iso8601(value)
    rescue ArgumentError => _e
      raise InvalidDate
    end

    def rate
      return BASE_RATE if @base_value == @convert_to

      valid_input?

      for_date = @database.fetch(date.to_s)
      for_date.fetch(@convert_to)
    rescue KeyError => _e
      raise OutOfRangeDate
    end

    private
      def valid_input?
        unless SUPPORTED_CURRENCIES.include?(@base_value.upcase) &&
          SUPPORTED_CURRENCIES.include?(@convert_to.upcase)
            raise InvalidCurrency
        end
      end
  end
end
