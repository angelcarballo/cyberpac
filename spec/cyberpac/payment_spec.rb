require 'spec_helper'

describe Cyberpac::Payment do
  let(:valid_config) {
    YAML.load(File.read(File.expand_path('../../support/valid_config.yml', __FILE__)))
  }

  let(:valid_payment_options) {
    YAML.load(File.read(File.expand_path('../../support/valid_payment_options.yml', __FILE__)))
  }

  before(:each) do
    Cyberpac.configure valid_config
  end

  describe '#initialize' do
    it 'fails if not configured' do
      Cyberpac.configure mode: 'invalid'
      expect { 
        Cyberpac::Payment.new(valid_payment_options) 
      }.to raise_error(Cyberpac::InvalidConfig)
    end

    it 'works with valid payment options' do
      expect { Cyberpac::Payment.new(valid_payment_options) }.not_to raise_error
    end

    it 'fails if any required key is missing' do
      Cyberpac::Payment::REQUIRED_KEYS.each do |key|
        expect { 
          Cyberpac::Payment.new valid_payment_options.merge([[key, nil]].to_h)  
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#endpoint' do
    it 'should match the selected mode' do
      Cyberpac.configure valid_config.merge(mode: :test)
      expect(
        Cyberpac::Payment.new(valid_payment_options).endpoint
      ).to eq(Cyberpac::Payment::TEST_ENDPOINT)

      Cyberpac.configure valid_config.merge(mode: :production)
      expect(
        Cyberpac::Payment.new(valid_payment_options).endpoint
      ).to eq(Cyberpac::Payment::PRODUCTION_ENDPOINT)
    end
  end

end
