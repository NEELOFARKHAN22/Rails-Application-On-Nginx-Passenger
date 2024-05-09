class SearchController < ApplicationController
  before_action :authenticate_user!
  def index
    @query = User.ransack(params[:q])
    @users = @query.result(distinct: true)
  end
end
