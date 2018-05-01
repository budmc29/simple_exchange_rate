require 'date'

RSpec.describe ExchangeRate do
  it 'has a version number' do
    expect(ExchangeRate::VERSION).not_to be nil
  end

  context 'with the default base currency' do
    it 'returns the base rate' do
      expect(described_class.at(Date.today, 'EUR', 'EUR')).
        to eq(1.0)
    end

    it 'returns the rate for another currency' do
      expect(described_class.at(Date.today, 'EUR', 'USD')).
        to eq(1.2079)
    end
  end

  context 'with non default base currency' do
    xit 'returns the rate for another currency' do
      expect(described_class.at(Date.today, 'GBP', 'USD')).
        to eq(0.99)
    end
  end
end
