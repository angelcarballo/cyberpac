require 'cyberpac/version'
require 'cyberpac/payment'
require 'yaml'

module Cyberpac
  CONFIG_KEYS = %w(merchant_code terminal_number secret mode currency locale)

  MODES = %i(test production)
  LOCALES = YAML.load_file(File.expand_path('../../support/locales.yml', __FILE__))
  CURRENCIES = YAML.load_file(File.expand_path('../../support/currencies.yml', __FILE__))

  DEFAULT_MODE = :test
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
      return self
    end

    def configured?
      merchant_code && terminal_number && secret && MODES.include?(mode) &&
        LOCALES.include?(locale) && CURRENCIES.include?(currency)
    end

    def mode
      (@mode ||= DEFAULT_MODE).to_sym
    end

    def locale
      (@locale ||= DEFAULT_LOCALE).to_sym
    end

    def currency
      (@currency ||= DEFAULT_CURRENCY).to_sym
    end

    def locale_code
      LOCALES[locale]
    end

    def currency_code
      CURRENCIES[currency]
    end

  end

  # Exceptions
  class InvalidConfig < StandardError; end
end

