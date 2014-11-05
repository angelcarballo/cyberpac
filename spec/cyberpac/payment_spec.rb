require 'spec_helper'

describe Cyberpac::Payment do
   let(:valid_config) {
      YAML.load(File.read(File.expand_path('../support/valid_config.yml', __FILE__)))
   }

   describe '#initialize' do
      it 'requires previous configuration' do
         expect { subject.new }.to raise_error(Cyberpac::InvalidConfig)
      end
   end

end
