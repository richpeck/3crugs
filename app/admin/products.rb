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
require 'csv'         # => Read CSV
require 'open-uri'    # => Download file
require 'zip'         # => Unzip archive
require 'sidekiq/api' # => Allows us to check if queue is running

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
    actions :index,:destroy

    # => Action Button (top right)
    action_item "Destroy" do
      link_to "❌ Destroy All", destroy_all_admin_products_path, method: :delete  if Product.any?
    end

    # => Action Button (top right)
    action_item "Sync" do
      scheduled = Sidekiq::ScheduledSet.new
      #puts scheduled.size

      if Sidekiq::Queue.new("sync").size > 0
        link_to "🕒 Queue Processing (#{Sidekiq::Queue.new('sync').size} Items Left)", cancel_sync_admin_products_path, method: :delete, title: "Cancel"
      else
        link_to "✔️ Sync All", sync_all_admin_products_path, method: :post if Product.any?
      end
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
      column "Stock",        :free_stock
      column "On Order",     :on_order
      column "ETA",          :eta
      column "Response",     :response
      column "Synced At",    :synced_at
      column                 :created_at
      column                 :updated_at
      actions name: "Actions", default: true do |product|
        link_to "✔️", sync_admin_product_path(product), title: "Sync", style: "text-decoration: none; vertical-align: center;", method: :post
      end
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
    ## Member Actions
    ##################################
    ##################################

    # => Sync
    # => Allows us to sync individual products
    member_action :sync, method: :post do
      resource.sync!
      redirect_to collection_path, notice: "#{resource.vad_description} synced successfully"
    end

    ##################################
    ##################################
    ## Batch Actions
    ##################################
    ##################################

    # => Sync
    # => Allows us to sync specific products
    batch_action :sync do |ids|
      batch_action_collection.find(ids).each do |product|
        product.sync!
      end
      redirect_to collection_path, notice: "Sync started!"
    end

    ##################################
    ##################################
    ## Top Right (Actions)
    ##################################
    ##################################

    # => Cancel Sync
    collection_action :cancel_sync, method: :delete do
      Sidekiq.redis { |conn| conn.flushall }
      redirect_to collection_path, notice: "Queue cancelled (#{Sidekiq::Queue.new('sync').size} items)"
    end

    # => Destroy All
    # => Allows us to remove all elements of single entry
    collection_action :destroy_all, method: :delete do
      Sidekiq.redis { |conn| conn.flushall }
      Product.delete_all
      redirect_to collection_path, notice: "Products deleted successfully!"
    end

    # => Sync All
    collection_action :sync_all, method: :post do
      Product.sync_all
      redirect_to collection_path, notice: "Products synced successfully!"
    end

    # => Custom Action
    # => Allows us to import/update products from the CSV
    collection_action :import do

      # => Allows us to download the file
      # => Should have logic here, but moved to model because Whenever gem needed it
      Product.download_csv

      # => Redirect to collection path
      redirect_to collection_path, notice: "Products imported successfully!"
    end

  end

  ############################################################
  ############################################################

end

############################################################
############################################################
