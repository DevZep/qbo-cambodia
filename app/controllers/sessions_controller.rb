class SessionsController < Devise::SessionsController

  protected

  def auth_options
    { recall: 'home#index', scope: :user }
  end
end
