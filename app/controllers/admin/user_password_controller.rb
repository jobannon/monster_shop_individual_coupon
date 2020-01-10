class Admin::UserPasswordController < Admin::BaseController
  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    user.update(password_params)
    if user.save
      flash[:happy] = 'Password Updated Successfully'
      redirect_to "/admin/users/#{user.id}"
    else
      flash[:sad] = 'Passwords do not match'
      redirect_back fallback_location: "/admin/users/#{user.id}/edit-pw"
    end
  end

  private

  def password_params
    params.permit(:password, :password_confirmation)
  end
end
