# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SimpleExchangeRate do
  describe '#at' do
    it 'returns a valid result' do
      allow_any_instance_of(described_class::Conversion).
        to receive(:rate).and_return(1.2345)

      expect(described_class.at(Date.today, 'EUR', 'USD')).to be_truthy
    end
  end
end
