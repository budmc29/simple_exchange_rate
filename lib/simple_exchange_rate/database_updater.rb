# frozen_string_literal: true

require 'open-uri'

require_relative 'database'

module SimpleExchangeRate
  class DatabaseUpdater
    API_URL = 'http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml'

    def self.call
      online_file = OpenURI.open_uri(URI(API_URL))

      file_path = DATABASE_FILE_PATH + '/exchange_rates.xml'

      f = File.new(file_path, 'w')
      f.write(online_file.read)
      f.close
    end
  end
end
