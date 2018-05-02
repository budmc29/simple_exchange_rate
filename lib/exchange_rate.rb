require 'exchange_rate/version'
require 'exchange_rate/database'
require 'exchange_rate/currency'

module ExchangeRate
  class << self
    def at(date, from_currency, to_currency)
      currency = self::Currency.new(database)

      currency.base_value = from_currency
      currency.convert_to = to_currency
      currency.date = date

      currency.rate
    end

    def database
      @database ||= Database.all
    end
  end
end
