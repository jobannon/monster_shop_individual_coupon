class Admin::UsersController < Admin::BaseController
  def index
    @users = User.all.order(:role, :name)
  end

  def show
    @user = User.find(params[:id])
  end

  def update

  end

  def edit
    @new_user = User.find(params[:id])
  end 
end
