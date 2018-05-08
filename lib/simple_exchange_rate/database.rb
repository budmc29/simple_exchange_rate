# frozen_string_literal: true

require 'nokogiri'

module SimpleExchangeRate
  DATABASE_FILE_PATH = File.expand_path('../../db', __dir__)
  DATABASE_FILE_NAME = 'exchange_rates.xml'
  DATABASE_FILE = DATABASE_FILE_PATH + '/' + DATABASE_FILE_NAME

  class Database
    def initialize(file = File.open(DATABASE_FILE))
      @file = Nokogiri::XML(file)
      @file.remove_namespaces!
    end

    def all
      daily_rates.reduce({}) do |all_rates, daily_rate|
        day = daily_rate.attributes['time'].value

        all_rates[day] = rates_details(daily_rate)

        all_rates
      end
    end

    private

    def daily_rates
      @file.xpath('//Cube[not(@*)]').xpath('Cube')
    end

    def rates_details(rate)
      entries = rate.xpath('Cube')

      entries.reduce({}) do |all_entries, entry|
        all_entries[entry[:currency]] = entry[:rate]
        all_entries
      end
    end
  end
end
