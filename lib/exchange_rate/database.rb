module ExchangeRate
  class Database
    def self.all
      {
        Date.today.to_s => {
          'USD' => 1.2079
        }
      }
    end
  end
end
