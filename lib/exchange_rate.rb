require 'exchange_rate/version'
require 'exchange_rate/database'

module ExchangeRate
  BASE_CURRENCY = 'EUR'
  BASE_RATE = 1.0

  def self.at(date, from_currency, to_currency)
    # TODO validate date
    # TODO validate currency type and values

    currencies = Database.all

    return BASE_RATE if from_currency == to_currency

    currencies.fetch(date.to_s).fetch(to_currency)
  end
end
