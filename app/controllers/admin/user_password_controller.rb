class Admin::UserPasswordController < Admin::BaseController
  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    user.password = params[:password]
    user.password_confirmation = params[:password_confirmation]
    if user.save
      flash[:happy] = 'Password Updated Successfully'
      redirect_to "/admin/users/#{user.id}"
    else
      flash[:sad] = 'Passwords do not match'
      redirect_back fallback_location: "/admin/users/#{user.id}/edit-pw"
    end
  end
end
