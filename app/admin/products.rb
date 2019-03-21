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

    # => Params
    permit_params :email, :password, :password_confirmation, profile_attributes: [:id, :name, :role, :public, :avatar]  # => :avatar_attributes: [:id, FL::FILE, :_destroy] // This used to give us deep nested model - but can just attach the asset directly without custom table now

    ##################################
    ##################################

    # => Actions
    actions :index, :import, :destroy

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

    # => Custom Action
    # => Allows us to import/update products from the CSV
    collection_action :import do

      # => Vars
      api = Meta::Option.find_by(ref: "app_ekm").val || nil
      zip = Meta::Option.find_by(ref: "app_csv").val || nil

      # => Download CSV from Dropbox
      # => This can be done through HTTP (no need for API)
      file = open zip
      Zip::File.open(file) do |zipfile|
        zipfile.each do |file|
          if file.to_s.strip == "Think Rugs Stock.csv"
            puts "hit"
          end
        end
      end

      # => Populate table with data
      # => This should create or update present data
      # => https://www.rubyguides.com/2018/10/parse-csv-ruby/
      csv = CSV.read csv_text, headers: true
      csv.each do |row|
        Product.find_or_create_by(vad_variant_code: row["vad_variant_code"], vad_description: row["vad_description"], vad_ean_code: row["vad_ean_code"], free_stock: row["free_stock"], on_order: row["on_order"], eta: row["on_order"])
      end

      # => Redirect to collection path
      redirect_to collection_path, notice: "Products imported successfully!"
    end

  end

  ############################################################
  ############################################################

end

############################################################
############################################################
