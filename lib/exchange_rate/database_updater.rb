require 'open-uri'

module ExchangeRate
  class DatabaseUpdater
    API_URL = "http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml"
    DATABASE_FILE_PATH = File.expand_path('../../../db', __FILE__)

    def self.call
      online_file = open(URI(API_URL))

      file_path = DATABASE_FILE_PATH + '/exchange_rate.xml'

      f = File.new(file_path, 'w')
      f.write(online_file.read)
      f.close
    end
  end
end
