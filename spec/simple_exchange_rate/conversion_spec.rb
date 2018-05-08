# frozen_string_literal: true

require 'spec_helper'

class StubDatabase
  def all
    {
      Date.today.to_s => {
        'GBP' => '0.8804',
        'USD' => '1.2007',
        'IDR' => '16762.27'
      }
    }
  end
end

RSpec.describe SimpleExchangeRate::Conversion do
  describe '#rate' do
    let(:database) { StubDatabase.new }

    subject do
      sub = described_class.new(database)

      sub.date = date
      sub.base_currency = base_currency
      sub.conversion_currency = conversion_currency

      sub.rate
    end

    let(:base_currency) { 'EUR' }
    let(:neutral_rate) { 1.0 }
    let(:conversion_currency) { 'USD' }
    let(:base_to_conversion_rate) { 1.2007 }
    let(:date) { Date.today.to_s }

    context 'with database failure' do
      let(:database) { double('database') }

      it 'raises database error' do
        allow(database).to receive(:all).and_raise(KeyError)

        expect { subject }.to raise_error(SimpleExchangeRate::DatabaseError)
      end
    end

    context 'with invalid base currency' do
      let(:base_currency) { 'xx' }

      it do
        expect { subject }.to raise_error(SimpleExchangeRate::InvalidCurrency)
      end
    end

    context 'with invalid conversion currency' do
      let(:conversion_currency) { 'xx' }

      it do
        expect { subject }.to raise_error(SimpleExchangeRate::InvalidCurrency)
      end
    end

    context 'with invalid date' do
      let(:date) { 'xx' }

      it do
        expect { subject }.to raise_error(SimpleExchangeRate::InvalidDate)
      end
    end

    context 'with non iso8601 date' do
      let(:date) { '01-05-2018' }

      it do
        expect { subject }.to raise_error(SimpleExchangeRate::InvalidDate)
      end
    end

    context 'with the default base currency' do
      describe 'and the same conversion currency' do
        let(:conversion_currency) { base_currency }

        it 'returns neutral rate' do
          expect(subject).to eq(neutral_rate)
        end
      end

      it 'returns a valid rate' do
        expect(subject).to eq(base_to_conversion_rate)
      end

      describe 'and date not in the database' do
        let(:date) { Date.today - 1 }

        it 'raises exception' do
          expect { subject }.to raise_error(SimpleExchangeRate::OutOfRangeDate)
        end
      end
    end

    context 'with non default base currency' do
      describe 'when converting to a currency other than default' do
        let(:base_currency) { 'GBP' }
        let(:non_base_to_conversion_rate) { 1.3638 }

        it 'returns the correct rate' do
          expect(subject).to eq(non_base_to_conversion_rate)
        end
      end

      describe 'with a currency that has a big rate' do
        let(:base_currency) { 'GBP' }
        let(:conversion_currency) { 'IDR' }
        let(:non_base_to_conversion_rate) { 19_039.3798 }

        it 'returns the correct rate' do
          expect(subject).to eq(non_base_to_conversion_rate)
        end
      end

      describe 'when converting to base currency' do
        let(:base_currency) { 'USD' }
        let(:conversion_currency) { 'EUR' }
        let(:new_base_to_default_base_rate) { 0.8328 }

        it 'returns the correct rate' do
          expect { subject }.to_not raise_error
          expect(subject).to eq(new_base_to_default_base_rate)
        end
      end
    end
  end
end
