require 'date'

RSpec.describe ExchangeRate do
  let(:base_currency) { 'EUR' }
  let(:non_base_currency) { 'GBP' }
  let(:valid_date) { '2018-05-01' }
  let(:conversion_currency) { 'USD' }

  it 'has a version number' do
    expect(ExchangeRate::VERSION).not_to be nil
  end

  describe '.at' do
    it 'requires valid base currency' do
      expect {
        described_class.at(valid_date, 'xx', conversion_currency)
      }.to raise_error(ExchangeRate::InvalidCurrency)
    end

    it 'requires valid conversion currency' do
      expect {
        described_class.at(valid_date, base_currency, 'xx')
      }.to raise_error(ExchangeRate::InvalidCurrency)
    end

    context 'with the default base currency' do
      it 'returns the base rate' do
        expect(described_class.at(valid_date, base_currency, base_currency)).
          to eq(1.0)
      end

      it 'returns the rate for another currency' do
        expect(described_class.at(valid_date, base_currency, conversion_currency)).
          to eq(1.2079)
      end

      context 'with ill-formatted date' do
        it 'rejects it' do
          expect {
            described_class.at('x', base_currency, conversion_currency)
          }.to raise_error(ExchangeRate::InvalidDate)
        end

        it 'rejects non iso8601 date' do
          expect {
            described_class.at('01-05-2018', base_currency, conversion_currency)
          }.to raise_error(ExchangeRate::InvalidDate)
        end
      end

      context 'with date not in the database' do
        it 'raises exception' do
          expect {
            described_class.at('2018-01-01', base_currency, conversion_currency)
          }.to raise_error(ExchangeRate::OutOfRangeDate)
        end
      end
    end

    context 'with non default base currency' do
      xit 'returns the rate for another currency' do
        expect(described_class.at(valid_date, non_base_currency, conversion_currency)).
          to eq(0.99)
      end
    end
  end
end
