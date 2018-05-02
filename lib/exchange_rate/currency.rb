module ExchangeRate
  class InvalidCurrency < Exception; end

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
    attr_accessor :base_rate, :convert_to, :date

    def initialize(database)
      @database = database
    end

    def rate
      return BASE_RATE if @base_rate == @convert_to

      valid_input?

      for_date = @database.fetch(date.to_s)
      for_date.fetch(@convert_to)
    end

    private
      def valid_input?
        unless SUPPORTED_CURRENCIES.include?(@base_rate.upcase) &&
          SUPPORTED_CURRENCIES.include?(@convert_to.upcase)
            raise InvalidCurrency
        end
      end
  end
end
