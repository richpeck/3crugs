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

# => Dependencies
require 'csv'       # => Read CSV
require 'open-uri'  # => Download file
require 'zip'       # => Unzip archive

############################################################
############################################################

# => Check if ActiveAdmin loaded
if Object.const_defined?('ActiveAdmin')

  ############################################################
  ############################################################

  ## Users ##
  ActiveAdmin.register Product do

    ##################################
    ##################################

    # => Vars
    @@name = ["📦", Product.model_name.human(count: 2)].join(' ')

    # => Menu
    menu priority: 3, label: -> { @@name }

    # => Default Sort Order
    config.sort_order = 'vad_variant_code_asc'

    ##################################
    ##################################

    # => Actions
    actions :index, :import, :destroy, :destroy_all

    # => Action Button (top right)
    action_item "Destroy" do
      link_to "❌ Destroy All", destroy_all_admin_products_path, method: :delete
    end

    # => Action Button (top right)
    action_item "Import" do
      link_to "💾 Import CSV", import_admin_products_path
    end

    ##################################
    ##################################

    # => Index
    # => Shows the extant products
    index title: @@name do
      selectable_column
      column "Product Code", :vad_variant_code
      column "Description",  :vad_description
      column "EAN",          :vad_ean_code
      column "Stock",        :free_stock
      column "On Order",     :on_order
      column "ETA",          :eta
      column :created_at
      column :updated_at
      actions
    end

    # =>  Form (Edit/New)
    form title: proc { |product| ['Editing', product.product_code].join(' ') } do |f|
      f.inputs "Details" do
        f.input :vad_variant_code,  inner_html: { placeholder: "Product Code" }
        f.input :vad_description,   inner_html: { placeholder: "Description" }
        f.input :vad_ean_code
        f.input :free_stock
        f.input :on_order
        f.input :eta
      end
      f.actions
    end

    ##################################
    ##################################

    # => Destroy All
    # => Allows us to remove all elements of single entry
    collection_action :destroy_all, method: :delete do
      Product.delete_all
      redirect_to collection_path, notice: "Products deleted successfully!"
    end

    # => Custom Action
    # => Allows us to import/update products from the CSV
    collection_action :import do

      # => Vars
      api = Meta::Option.find_by(ref: "app_ekm").val || nil
      zip = Meta::Option.find_by(ref: "app_csv").val || nil

      # => Scoped vars
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
      csv.each do |x|
        x.merge!({created_at: DateTime.now})
        x.merge!({updated_at: DateTime.now})
      end
      Product.upsert_all(csv) # => https://edgeapi.rubyonrails.org/classes/ActiveRecord/Persistence/ClassMethods.html#method-i-upsert_all

      # => Redirect to collection path
      redirect_to collection_path, notice: "Products imported successfully!"
    end

  end

  ############################################################
  ############################################################

end

############################################################
############################################################
