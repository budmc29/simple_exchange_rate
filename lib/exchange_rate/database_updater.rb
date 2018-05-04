require 'open-uri'

require 'exchange_rate/database'

module ExchangeRate
  class DatabaseUpdater
    API_URL = "http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml"

    def self.call
      online_file = open(URI(API_URL))

      file_path = DATABASE_FILE_PATH + '/exchange_rate.xml'

      f = File.new(file_path, 'w')
      f.write(online_file.read)
      f.close
    end
  end
end
