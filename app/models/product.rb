############################################################
############################################################
##        _____              _            _               ##
##       | ___ \            | |          | |              ##
##       | |_/ / __ ___   __| |_   _  ___| |_ ___         ##
##       |  __/ '__/ _ \ / _` | | | |/ __| __/ __|        ##
##       | |  | | | (_) | (_| | |_| | (__| |_\__ \        ##
##       \_|  |_|  \___/ \__,_|\__,_|\___|\__|___/        ##
##                                                        ##
############################################################
############################################################
## Populated from CSV file
## Allows us to keep system up to date & manage which ones will be synced over the API
############################################################
############################################################

## Dependencies ##
require 'savon'     # => SOAP API management

############################################################
############################################################

## Product ##
class Product < ApplicationRecord

  # =>  Validations
  validates :vad_variant_code, presence: true, uniqueness: true

  # => Aliases
  alias_attribute :product_code, :vad_variant_code

  # => Sync
  # => Uses Savon gem to communicate with EKM API
  # => All we're going to do is ping the API with the ProductCode and update the Stock number
  # => https://engineering.tripping.com/savon-soap-in-ruby-6e6fce06537b
  def sync!

    # => Vars
    api = Meta::Option.find_by(ref: "app_ekm").val

    # => Savon
    # => This allows us to send the request
    # => https://stackoverflow.com/q/26990946/1143732
    client = Savon.client do
      wsdl "http://publicapi.15.ekm.net/v1.1/publicapi.asmx?WSDL"
      endpoint "http://publicapi.15.ekm.net/v1.1/publicapi.asmx"
      env_namespace :soap
      namespace_identifier nil
      strip_namespaces true
      pretty_print_xml true
      element_form_default :unqualified
      convert_request_keys_to :camelcase
      namespaces "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance", "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema", "xmlns:soap" => "http://schemas.xmlsoap.org/soap/envelope/"
      logger Rails.logger
      log true
    end

    # => To raise errors
    begin
      client.call(:set_product_stock, message: { SetProductStockRequest: { APIKey: api, ProductCode: vad_variant_code, ProductStock: free_stock }} )
    rescue Savon::Error => error
      Rails.logger.info error.inspect()
      raise
    end

    # => Update the db
    update synced_at: DateTime.now
  end

end

############################################################
############################################################
