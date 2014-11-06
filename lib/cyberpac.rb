require "cyberpac/version"
require "cyberpac/payment"

module Cyberpac
  CONFIG_KEYS = %w(merchant_code terminal_number secret mode)
  MODES = %w(test production)
  LOCALES = YAML.load(File.read(File.expand_path('../../support/locales.yml', __FILE__)))
  CURRENCIES = YAML.load(File.read(File.expand_path('../../support/currencies.yml', __FILE__)))
  DEFAULT_CURRENCY = :eur
  DEFAULT_LOCALE = :es

  class << self
    attr_accessor *CONFIG_KEYS

    # options must use symbols
    def configure(options = {})
      if block_given?
        yield self
      else
        CONFIG_KEYS.each {|key| instance_variable_set "@#{key}", options[key.to_sym]}
      end
    end

    def configured?
      merchant_code && terminal_number && secret && MODES.include?(mode)
    end

  end

  # Exceptions
  class InvalidConfig < StandardError; end
end

