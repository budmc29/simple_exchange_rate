require 'exchange_rate/version'
require 'exchange_rate/database'
require 'exchange_rate/currency'

module ExchangeRate
  class InvalidDate < Exception; end
  class OutOfRangeDate < Exception; end

  class << self
    def at(date, from_currency, to_currency)
      currency = self::Currency.new(database)

      currency.base_rate = from_currency
      currency.convert_to = to_currency
      currency.date = Date.iso8601(date)

      currency.rate
    rescue KeyError => _e
      raise OutOfRangeDate
    rescue ArgumentError => _e
      raise InvalidDate
    end

    def database
      @database ||= Database.all
    end
  end
end
