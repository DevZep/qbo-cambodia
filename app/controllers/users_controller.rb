# frozen_string_literal: true
class UsersController < ApplicationController
  def show
    @companies = current_user.qbo_credentials
  end
end
