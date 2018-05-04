require 'spec_helper'

RSpec.describe ExchangeRate::Database do
  describe '#all' do
    subject { described_class.new(stub_file) }

    it 'parses the xml file and returns all the currencies' do
      expect(subject.all).to eq(valid_parsed_result)
    end
  end
end

def stub_file
<<-XML
  <?xml version="1.0" encoding="UTF-8"?>
  <gesmes:Envelope xmlns:gesmes="http://www.gesmes.org/xml/2002-08-01" xmlns="http://www.ecb.int/vocabulary/2002-08-01/eurofxref">
    <gesmes:subject>Reference rates</gesmes:subject>
    <gesmes:Sender><gesmes:name>European Central Bank</gesmes:name>
    </gesmes:Sender>

    <Cube>
      <Cube time="2018-05-03">
        <Cube currency="USD" rate="1.1992"/>
        <Cube currency="GBP" rate="0.8818"/>
      </Cube>
      <Cube time="2018-05-02">
        <Cube currency="USD" rate="1.2007"/>
        <Cube currency="GBP" rate="0.8804"/>
      </Cube>
    </Cube>
  </gesmes:Envelope>
XML
end

def valid_parsed_result
  {
    "2018-05-02" => {"USD"=>"1.2007", "GBP"=>"0.8804"},
    "2018-05-03" => {"USD"=>"1.1992", "GBP"=>"0.8818"},
  }
end
