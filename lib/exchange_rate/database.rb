require 'nokogiri'

module ExchangeRate
  DATABASE_FILE_PATH = File.expand_path('../../../db', __FILE__)
  DATABASE_FILE_NAME = 'exchange_rate.xml'
  DATABASE_FILE = DATABASE_FILE_PATH + '/' + DATABASE_FILE_NAME

  class Database
    def initialize(file = File.open(DATABASE_FILE))
      @file = Nokogiri::XML(file)
      @file.remove_namespaces!
    end

    def all
      rates_by_day = @file.xpath("//Cube[not(@*)]").xpath("Cube")

      all_rates = {}
      rates_by_day.each do |rate|
        day = rate.attributes['time'].value

        currencies = rate.xpath("Cube")

        day_currencies = {}
        currencies.each do |currency|
          day_currencies[currency[:currency]] = currency[:rate]
        end

        all_rates[day] = day_currencies
      end

      all_rates
    end
  end
end
