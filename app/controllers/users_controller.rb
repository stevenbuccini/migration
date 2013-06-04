class UsersController < ApplicationController
  def index
  	 
  end

  def map
  	@user = User.from_omniauth(env["omniauth.auth"])

  end


end
