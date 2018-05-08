# frozen_string_literal: true

require 'simple_exchange_rate/version'
require 'simple_exchange_rate/database'
require 'simple_exchange_rate/conversion'

module SimpleExchangeRate
  class << self
    def at(date, base_currency, conversion_currency)
      conversion = self::Conversion.new(database)

      conversion.date = date
      conversion.base_currency = base_currency
      conversion.conversion_currency = conversion_currency

      conversion.rate
    end

    private

    def database
      @database ||= Database.new
    end
  end
end
