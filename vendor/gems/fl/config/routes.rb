########################################
########################################
##    _____            _              ##
##   | ___ \          | |             ##
##   | |_/ /___  _   _| |_ ___  ___   ##
##   |    // _ \| | | | __/ _ \/ __|  ##
##   | |\ \ (_) | |_| | ||  __/\__ \  ##
##   \_| \_\___/ \__,_|\__\___||___/  ##
##                                    ##
########################################
########################################

## Good resource
## https://gist.github.com/maxivak/5d428ade54828836e6b6#merge-engine-and-app-routes

########################################
########################################

## Routes ##
Rails.application.routes.draw do

  ########################################
  ########################################

    # => ActiveAdmin
    # => Used to provide an "admin" area for users (won't need this with RailsHosting's dashboard)
    if Object.const_defined?("ActiveAdmin")

      # => CKEditor
      mount Ckeditor::Engine => '/ckeditor' if Object.const_defined?("Ckeditor")

      # => Routes
      devise_for :users, ActiveAdmin::Devise.config
      ActiveAdmin.routes(self)

    end

  ########################################
  ########################################

    # Index
    # => Shows index of app
    root "admin/products#index"

  ########################################
  ########################################

end
