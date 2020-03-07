require 'mupdater'

RSpec.describe 'test of mupdate' do
  describe 'os_check' do
    example 'if os is macosx is set' do
      expect(os_check).to eq true if os == :macosx
    end

    example 'if os is linux is set' do
      expect(os_check).to eq true if os == :linux
    end
  end
end
