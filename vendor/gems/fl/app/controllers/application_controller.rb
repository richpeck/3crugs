class ApplicationController < ActionController::Base

  ##################################
  ##################################

    # => Responders Gem
    respond_to :html

    # => Authentication
    http_basic_authenticate_with name: Rails.application.class.parent.to_s.downcase, password: "password" if Rails.env.staging?

  ##################################
  ##################################

    # => Settings
    # Header & Footer content defined in ApplicationHelper
    protect_from_forgery with: :exception

    # => Layout
    layout Proc.new { |c| Rails.application.credentials[Rails.env.to_sym][:app][:layout] || 'base' unless c.request.xhr? }

    # => Maintenance
    before_action Proc.new { @maintenance = Node.find_by(ref: "maintenance").try(:val) }, only: :show

  ##################################
  ##################################

    # => Robots.txt
    # => http://api.rubyonrails.org/classes/ActionController/ConditionalGet.html#method-i-expires_in
    def robots
      expires_in 5.hours, public: true
      render plain: "User-agent: *\r\nSitemap: https://www.railshosting.com/sitemap.xml.gz"
    end

  ##################################
  ##################################

  private

    # => Devise
    # => Sign In
    def after_sign_in_path_for(resource)
      Rails.application.routes.named_routes[:admin_root] ? admin_root_path : root_path
    end

    # => Devise
    # => Sign Out
    def after_sign_out_path_for(resource_or_scope)
      root_path
    end

    # => Params
    def node_params
      params.require(:node).permit(:ref, :val)
    end

 ##################################

end
