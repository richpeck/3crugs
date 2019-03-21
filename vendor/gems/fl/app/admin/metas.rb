############################################################
############################################################
##               __  __      _                            ##
##              |  \/  |    | |                           ##
##              | .  . | ___| |_ __ _ ___                 ##
##              | |\/| |/ _ \ __/ _` / __|                ##
##              | |  | |  __/ || (_| \__ \                ##
##              \_|  |_/\___|\__\__,_|___/                ##
##                                                        ##
############################################################
############################################################

## Info ##
models = {
  option:       {priority: 3},
  page:         {priority: 4},
  platform:     {priority: 5},
  plan:         {priority: 6},
  performance:  {resource: 'performance'},
  rating:       {priority: 11}
}
############################################################
############################################################

# => Check if ActiveAdmin loaded
if Object.const_defined?('ActiveAdmin')

  ############################################################
  ############################################################

  ## Make Sure Table Exists ##
  if ActiveRecord::Base.connection.table_exists? 'nodes'

    ## Get all Meta Models ##
    Node.where(title: 'meta').where.not(val: 'role').pluck(:val).each do |meta|

      ## Check ##
      unless (model = "Meta::#{meta.capitalize}".constantize rescue nil).nil?

      ############################################################
      ############################################################

        # => Model
        ActiveAdmin.register model, as: models.try(:[], meta.to_sym).try(:[], :resource) || meta.to_s do

          ##################################
          ##################################

          # => Scopes
          if meta.to_sym == :option
            scope '💥 All', default: true do |option|
              option.excluding ['feature','location', 'section']
            end
            scope ('👑 Features')  { |node| node.ref :feature }
            scope ('🗺️ Locations') { |node| node.ref :location }
            scope ('📎 Sections')   { |node| node.ref :section }
          end

          ##################################
          ##################################

          # => Menu
          menu priority: models.try(:[], meta.to_sym).try(:[], :priority), label: -> { [I18n.t("activerecord.models.meta/#{meta}.icon"), (models.try(:[], meta.to_sym).try(:[], :label) || model.model_name.human(count: 2))].join(' ') }

          ##################################
          ##################################

          # => Strong Params
          permit_params :slug, :ref, :val

          ##################################
          ##################################

          # => Index
          index title: [I18n.t("activerecord.models.meta/#{meta}.icon"), (models.try(:[], meta.to_sym).try(:[], :label) || model.model_name.human(count: 2)), '|', Rails.application.credentials[Rails.env.to_sym][:app][:name] ].join(' ') do
            selectable_column
            if meta.to_sym == :platform
              column "Logo", :title do |platform|
                platform.try(:logo) || platform.title
              end
            else
              column :title
            end
            column "Info" do |x|
              x.value.html_safe
            end
            if meta.to_sym == :platform
              Node.ref('feature').pluck(:val).each do |feature|
                column feature
              end
            end
            %i(created_at updated_at).each do |x|
              column x
            end
            actions
          end

          ##################################
          ##################################

          # =>  Form
          form multipart: true, title: [I18n.t("activerecord.models.meta/#{meta}.icon"), (models.try(:[], meta.to_sym).try(:[], :label) || model.model_name.human(count: 2))].join(' ') do |f|
            f.inputs 'Details' do
              f.input :slug if meta.to_sym == :page
              f.input :ref
              f.input :val, as: :trix_editor
            end

            f.actions
        	end

        end

        ############################################################
        ############################################################

      end
    end
  end

  ############################################################
  ############################################################

end

############################################################
############################################################
