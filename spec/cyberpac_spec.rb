require 'spec_helper'

describe Cyberpac do
  let(:valid_config) {
    YAML.load_file File.expand_path('../support/valid_config.yml', __FILE__)
  }

  describe '.configure' do
    before(:each) do # reset configuration
      Cyberpac::CONFIG_KEYS.each {|key| Cyberpac.public_send("#{key}=", nil)}
    end

    it 'should setup config keys with params' do
      subject.configure(valid_config)
      expect(subject.merchant_code).to   eq(valid_config[:merchant_code])
      expect(subject.terminal_number).to eq(valid_config[:terminal_number])
      expect(subject.secret).to          eq(valid_config[:secret])
      expect(subject.mode).to            eq(valid_config[:mode])
      expect(subject.currency).to        eq(valid_config[:currency])
      expect(subject.locale).to          eq(valid_config[:locale])
    end

    it 'should setup config keys with block' do
      Cyberpac.configure do |config|
        config.merchant_code   = valid_config[:merchant_code]
        config.terminal_number = valid_config[:terminal_number]
        config.secret          = valid_config[:secret]
        config.mode            = valid_config[:mode]
      end
      expect(subject.merchant_code).to   eq(valid_config[:merchant_code])
      expect(subject.terminal_number).to eq(valid_config[:terminal_number])
      expect(subject.secret).to          eq(valid_config[:secret])
      expect(subject.mode).to            eq(valid_config[:mode])
      expect(subject.currency).to        eq(valid_config[:currency])
      expect(subject.locale).to          eq(valid_config[:locale])
    end
  end

  describe '.configured?' do
    it "should be true with valid options" do
      subject.configure(valid_config)
      expect(subject.configured?).to be
    end
    it "should be false with invalid mode" do
      subject.configure(valid_config.merge(mode: 'invalid-mode'))
      expect(subject.configured?).to_not be
    end
    it "should be false if merchant_code is missing" do
      subject.configure(valid_config.merge(merchant_code: nil))
      expect(subject.configured?).to_not be
    end
    it "should be false if terminal_number is missing" do
      subject.configure(valid_config.merge(terminal_number: nil))
      expect(subject.configured?).to_not be
    end
    it "should be false if secret is missing" do
      subject.configure(valid_config.merge(secret: nil))
      expect(subject.configured?).to_not be
    end
  end

  describe '.mode' do
    it 'should have a default value (test)' do
      subject.configure(valid_config.merge(mode: nil))
      expect(subject.mode).to eq(Cyberpac::DEFAULT_MODE)
    end
  end

  describe '.locale' do
    it 'should have a default value (es)' do
      subject.configure(valid_config.merge(locale: nil))
      expect(subject.locale).to eq(Cyberpac::DEFAULT_LOCALE)
    end
  end

  describe '.currency' do
    it 'should have a default value (eur)' do
      subject.configure(valid_config.merge(currency: nil))
      expect(subject.currency).to eq(Cyberpac::DEFAULT_CURRENCY)
    end
  end

end
