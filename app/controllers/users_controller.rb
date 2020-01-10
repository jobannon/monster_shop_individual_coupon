class UsersController < ApplicationController
  def new
  end

  def create
    @new_user = User.new(user_params)
    if @new_user.save
      flash[:notice]= "Welcome #{@new_user.name}"
      session[:user_id] = @new_user.id
      redirect_to '/profile'
    else
      flash[:notice] = @new_user.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @new_user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    user.update(user_params)
    if user.save
      update_happy_path(user)
    else
      update_sad_path(user)
    end
  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
  end

  def update_happy_path(user)
    flash[:happy] = "Data updated successfully"
    redirect_to "/profile" and return if current_user.default?
    redirect_to "/admin/users/#{user.id}" if current_user.admin?
  end

  def update_sad_path(user)
    flash[:notice] = user.errors.full_messages.to_sentence
    redirect_to "/admin/users/#{user.id}/edit" and return if current_user.admin?
    redirect_to "/users/#{user.id}/edit" if current_user.default?
  end
end
