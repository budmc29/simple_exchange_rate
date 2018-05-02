module ExchangeRate
  class Database
    class << self
      def self.all
        {
          '2018-05-01' => {
            'USD' => 1.2079
          }
        }
      end
    end
  end
end
