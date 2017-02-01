# frozen_string_literal: true
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :redirect_devise_action
  before_action :authenticate_user!
  

  def css_class
    "#{controller_name}-#{action_name}"
  end

  def js_class
    action =
      case modified_action_name
      when 'create' then 'New'
      when 'update' then 'Edit'
      else modified_action_name
      end

    "Views.#{self.class.name.gsub('::', '.').gsub(/Controller$/, '')}.#{action.camelize}View"
  end

  helper_method :css_class, :js_class

  protected

  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end

  def after_sign_in_path_for(resource_or_scope)
    companies_path
  end

  def redirect_devise_action
    redirect_to root_path and return if controller_name == 'sessions' && action_name == 'new'
  end

  def modified_action_name
    case action_name
    when 'create' then 'new'
    when 'update' then 'edit'
    else action_name
    end
  end
end
