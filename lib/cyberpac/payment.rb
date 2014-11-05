class Cyberpac::Payment
  TEST_ENDPOINT = 'https://sis-t.sermepa.es:25443/sis/realizarPago'
  ENDPOINT = 'https://sis-t.sermepa.es:25443/sis/realizarPago'
  DEFAULT_CURRENCY = 978 # EUR
  DEFAULT_LANGUAGE = 1 # Spanish

  def initialize(options = {})
    raise Cyberpac::InvalidConfig unless Cyberpac.configured?
  end
end
