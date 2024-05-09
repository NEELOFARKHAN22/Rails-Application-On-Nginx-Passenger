class UserController < ApplicationController
   
  before_action :authenticate_user!
  def show
    @a = current_user
  end
  def index

    @user = User.all

  end
 
end
