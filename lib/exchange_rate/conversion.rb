# frozen_string_literal: true

require 'date'

module ExchangeRate
  class InvalidCurrency < RuntimeError; end
  class InvalidDate < RuntimeError; end
  class OutOfRangeDate < RuntimeError; end
  class DatabaseError < RuntimeError; end

  INITIAL_BASE_CURRENCY = 'EUR'
  BASE_RATE = 1.0
  PRECISION_NUMBER = 4
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
  ].freeze

  class Conversion
    attr_reader :date, :base_currency, :conversion_currency

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

      @base_currency = value
    end

    def conversion_currency=(value)
      raise InvalidCurrency unless valid_currency?(value)

      @conversion_currency = value
    end

    def rate
      return BASE_RATE if @base_currency == @conversion_currency

      raise OutOfRangeDate if rates_for_date.nil?

      if @base_currency == INITIAL_BASE_CURRENCY
        standard_rate
      else
        cross_rate
      end
    rescue KeyError
      raise DatabaseError
    end

    def rates_for_date
      @rates_for_date ||= @database.all.fetch(date.to_s, nil)
    end

    private

    def valid_currency?(value)
      return true if SUPPORTED_CURRENCIES.include?(value.to_s.upcase)
    end

    def standard_rate
      rates_for_date.fetch(@conversion_currency, nil).to_f
    end

    def converting_to_base_currency
      INITIAL_BASE_CURRENCY == @conversion_currency
    end

    def inverse_of_base_currency_rate
      (1 / rates_for_date.fetch(@base_currency).to_f).round(PRECISION_NUMBER)
    end

    def calculate_cross_rate_through_mutual_rate
      base_to_currency = rates_for_date.fetch(@conversion_currency).to_f
      base_to_new_base = rates_for_date.fetch(@base_currency).to_f

      (base_to_currency / base_to_new_base).round(PRECISION_NUMBER)
    end

    def cross_rate
      if converting_to_base_currency
        inverse_of_base_currency_rate
      else
        calculate_cross_rate_through_mutual_rate
      end
    end
  end
end
