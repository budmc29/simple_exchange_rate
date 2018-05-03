require 'exchange_rate/version'
require 'exchange_rate/database'
require 'exchange_rate/conversion'

module ExchangeRate
  class << self
    def at(date, base_currency, conversion_currency)
      conversion = self::Conversion.new(database)

      conversion.date = date
      conversion.base_currency = base_currency
      conversion.conversion_currency = conversion_currency

      conversion.rate
    end

    def database
      @database ||= Database.new
    end
  end
end
