require_relative '../../lib/exchange_rate/database_updater'

RSpec.describe ExchangeRate::DatabaseUpdater do
  describe '.call' do
    it 'fetches the online xml and saves it to a file' do
      online_file = double('online_file', read: 'body')
      file = instance_double('File', write: '', close: true)

      expect(OpenURI).to receive(:open_uri).and_return(online_file)

      expect(File).to receive(:new).and_return(file)
      expect(file).to receive(:write)
      expect(file).to receive(:close)

      expect { described_class.call}.to_not raise_error
    end
  end
end
