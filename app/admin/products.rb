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

    form title: proc { |user| ['Editing', user.name].join(' ') } do |f|
      f.inputs "Profile", for: [:profile, f.object.profile || f.object.build_profile] do |p|
        p.input :name
        p.input :role, include_blank: false
        p.input :public
        p.input :avatar, as: :file, hint: f.object.avatar.attached? ? image_tag(f.object.avatar.variant(resize: '150x150')) : content_tag(:span, "No Image Yet")
      end
      f.inputs "Details" do
        f.input :email
        f.input :password
        f.input :password_confirmation
      end
      f.actions
    end

  end

  ############################################################
  ############################################################

end

############################################################
############################################################
