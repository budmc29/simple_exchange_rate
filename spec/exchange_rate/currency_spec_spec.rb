require 'date'

RSpec.describe ExchangeRate::Currency do
  let(:database) { ExchangeRate::Database }

  describe '#rate' do
    subject do
      sub = described_class.new(StubDatabase.all)

      sub.base_value = base_currency
      sub.convert_to = convert_to
      sub.date = date

      sub.rate
    end

    let(:base_currency) { 'EUR' }
    let(:base_rate) {  1.2007 }
    let(:convert_to) { 'USD' }
    let(:date) { Date.today.to_s }
    let(:non_base_currency) { 'GBP' }
    let(:non_base_rate) { 1.1196 }

    class StubDatabase
      def self.all
        {
          Date.today.to_s => {
            'GBP' => 0.8804,
            'USD' => 1.2007
          }
        }
      end
    end

    context 'with invalid base currency' do
      let(:base_currency) { 'xx' }

      it do
        expect { subject }.to raise_error(ExchangeRate::InvalidCurrency)
      end
    end

    context 'with invalid conversion currency' do
      let(:convert_to) { 'xx' }

      it do
        expect { subject }.to raise_error(ExchangeRate::InvalidCurrency)
      end
    end

    context 'with invalid date' do
      let(:date) { 'xx' }

      it do
        expect { subject }.to raise_error(ExchangeRate::InvalidDate)
      end
    end

    context 'with non iso8601 date' do
      let(:date) { '01-05-2018' }

      it do
        expect { subject }.to raise_error(ExchangeRate::InvalidDate)
      end
    end

    context 'with the default base currency' do
      describe 'and the same conversion currency' do
        let(:convert_to) { base_currency }

        it 'returns neutral rate' do
          expect(subject).to eq(1.0)
        end
      end

      it 'returns a valid rate' do
        expect(subject).to eq(base_rate)
      end

      describe 'and date not in the database' do
        let(:date) { Date.new(2017).to_s }

        it 'raises exception' do
          expect { subject }.to raise_error(ExchangeRate::OutOfRangeDate)
        end
      end
    end

    context 'with non default base currency' do
      let(:base_currency) { non_base_currency }

      xit 'returns the correct rate' do
        expect(subject).to eq(non_base_rate)
      end
    end
  end
end
