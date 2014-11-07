require 'digest/sha1'

class Cyberpac::Payment
  REQUIRED_KEYS = %i(order_number amount_cents description client_name notify_url)
  OPTIONAL_KEYS = %i( success_url error_url merchant_data)
  CONFIG_KEYS = OPTIONAL_KEYS + REQUIRED_KEYS

  TEST_ENDPOINT = 'https://sis-t.sermepa.es:25443/sis/realizarPago'
  PRODUCTION_ENDPOINT = 'https://sis-t.sermepa.es:25443/sis/realizarPago'

  attr_accessor *CONFIG_KEYS

  def initialize(options = {})
    raise Cyberpac::InvalidConfig unless Cyberpac.configured?
    REQUIRED_KEYS.each do |key|
      raise ArgumentError, "missing config key :#{key}" unless options[key]
    end
    CONFIG_KEYS.each {|key| instance_variable_set "@#{key}", options[key]}
    return self
  end

  def endpoint
    ( Cyberpac.mode == :production ) ?  PRODUCTION_ENDPOINT : TEST_ENDPOINT
  end

  def gateway_data
    values = {
      'Ds_Merchant_MerchantCode'       => merchant_code,
      'Ds_Merchant_Terminal'           => Cyberpac.terminal_number.to_s.rjust(3, '0'),
      'Ds_Merchant_Amount'             => amount_cents.to_i.to_s,
      'Ds_Merchant_Order'              => order_number,
      'Ds_Merchant_ProductDescription' => description[0..124],
      'Ds_Merchant_Titular'            => client_name[0..59],
      'Ds_Merchant_Currency'           => Cyberpac.currency_code,
      'Ds_Merchant_TransactionType'    => '0', # payment authorization
      'Ds_Merchant_MerchantURL'        => notify_url,
      'Ds_Merchant_UrlOK'              => success_url,
      'Ds_Merchant_UrlKO'              => error_url,
      'Ds_Merchant_MerchantData'       => merchant_data,
      'Ds_Merchant_ConsumerLanguage'   => Cyberpac.locale_code
    }
    values['Ds_Merchant_MerchantSignature'] = calculate_signature(values)
    return values
  end


  private

  def calculate_signature(values)
    signature = %w(Ds_Merchant_Amount Ds_Merchant_Order Ds_Merchant_MerchantCode
                   Ds_Merchant_Currency Ds_Merchant_TransactionType Ds_Merchant_MerchantURL
                  ).collect {|f| values[f]}.join
    signature << secret
    Digest::SHA1.hexdigest signature
  end
end
