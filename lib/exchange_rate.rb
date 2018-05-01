require 'exchange_rate/version'
require 'exchange_rate/database'

module ExchangeRate
  class InvalidDate < Exception; end
  class OutOfRangeDate < Exception; end

  BASE_CURRENCY = 'EUR'
  BASE_RATE = 1.0

  def self.at(date, from_currency, to_currency)
    # TODO validate currency type and values
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
