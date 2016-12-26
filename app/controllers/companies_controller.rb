class CompaniesController < ApplicationController

	def index
		@companies = current_user.qbo_credentials
	end

	def show
		@company = current_user.qbo_credentials.find(params[:id])
	end
	
end