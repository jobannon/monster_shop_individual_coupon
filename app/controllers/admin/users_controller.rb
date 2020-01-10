class Admin::UsersController < Admin::BaseController
  def index
    @users = User.all.order(:role, :name)
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    if params[:status] == 'deactivate'
      deactivate(user)
    elsif params[:status] == 'activate'
      activate(user)
    end
    redirect_back fallback_location: '/admin/users'
  end

  def edit
    @new_user = User.find(params[:id])
  end 

  private

  def deactivate(user)
    user.update(active?: false)
    flash[:happy] = 'User Deactivated'
  end

  def activate(user)
    user.update(active?: true)
    flash[:happy] = 'User Activated'
  end
end
