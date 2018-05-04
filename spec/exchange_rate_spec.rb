require 'spec_helper'

RSpec.describe ExchangeRate do
  describe '#at' do
    it 'returns a valid result' do
      expect(described_class.at(Date.today, 'EUR', 'USD')).to be_truthy
    end
  end
end
