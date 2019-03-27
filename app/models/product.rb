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
require 'savon' # => SOAP API management

############################################################
############################################################

## Product ##
class Product < ApplicationRecord

  # =>  Validations
  validates :vad_variant_code, presence: true, uniqueness: true

  # => Aliases
  alias_attribute :product_code, :vad_variant_code

  # => Sync All
  # => Allows us to sync every product
  def self.sync_all

    # => Define Job
    # => This has to be done randomly because ActiveJob doesn't give any Job ID
    job = Meta::Sync.create ref: SecureRandom.uuid, val: "Started: #{DateTime.now}"

    # => Cycle
    # => Adds the various id's to the queue and then the sidekiq system goes through them
    self.ids.each do |product|
      SyncJob.perform_later product, job.ref
    end

  end

  # => Queue Size
  # => Should be in helper but had to move her eto get working with 'whenever' gem
  def self.queue_size
    scheduled = Sidekiq::ScheduledSet.new
    queued    = Sidekiq::Queue.new("sync")
    scheduled.size + queued.size
  end

  # => CSV
  # => Allows us to download the CSV
  def self.download_csv

    # => Vars
    api = Meta::Option.find_by(ref: "app_ekm").val || nil
    zip = Meta::Option.find_by(ref: "app_csv").val || nil

    # => Scoped vars
    # => Since these are called inside the loop, we need to declare them here to ensure they're accessible
    csv_file = nil
    path = nil

    # => Download CSV from Dropbox
    # => This can be done through HTTP (no need for API)
    file = open zip
    Zip::File.open(file) do |zipfile|
      zipfile.each do |file|
        if file.name.to_s.strip == "Think Rugs Stock.csv"
          path     = Rails.root.join("tmp", "cache", file.name.to_s)  # => ./tmp/cache/Think Rugs Stock.csv
          csv_file = zipfile.extract(file, path) { true }
        end
      end
    end

    # => Populate table with data
    # => This should create or update present data
    # => https://www.rubyguides.com/2018/10/parse-csv-ruby/
    csv = CSV.open(path, headers: :first_row).map(&:to_h) # => https://stackoverflow.com/a/48985892/1143732
    csv.map! { |x| x.deep_transform_keys { |key| key.to_s.gsub(' ', '').underscore } }

    # => Upsert All
    # => Allows us to update existing records and insert new ones
    # => https://edgeapi.rubyonrails.org/classes/ActiveRecord/Persistence/ClassMethods.html#method-i-upsert_all
    # => Added "insert" gem whilst upsert_all in beta - https://ankane.org/bulk-upsert
    #Product.upsert_all(csv)
    self.import csv,
      validate: false,
      on_duplicate_key_update: {
        conflict_target: [:vad_variant_code],
        columns: [:free_stock, :on_order, :eta]
      }

  end

  # => Response
  # => Allows us to return formatted response data
  def response
    if self[:response].present?
      body = ActiveSupport::HashWithIndifferentAccess.new JSON.parse(self[:response])
      status = body.dig("set_product_stock_response", "set_product_stock_result", "status") || ""
      error  = body.dig("set_product_stock_response", "set_product_stock_result", "errors", "string") || ""
      return error.blank? ? status : error
    end
  end

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
      log false
    end

    # => Response
    # => Allows us to record response delivered by the API
    # => Used "response" as attribute, use returned instead
    returned = client.call(:set_product_stock, message: { SetProductStockRequest: { APIKey: api, ProductCode: vad_variant_code, ProductStock: free_stock }} )

    # => Update DB
    # => Allows us to record exactly what happened
    # => Since API just spits out error responses, we can just record them (don't need to rescue any exceptions)
    update response: returned.body.to_json, synced_at: DateTime.now

    # => Return true or false
    # => This is to fix the "Too Many Requests" error
    raise StandardError, "Too Many Requests" if response.to_s.strip == "Too Many Requests"
  end

end

############################################################
############################################################
