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
    email_in_use = User.where('id != ? and email = ?',params[:id],params[:email]).count
    if email_in_use > 0
      flash[:notice] = 'Email address already in use by another user, please enter a different email address'
      @new_user = user
      render :edit
    end
    user.update(user_params)
    if user.save
      flash[:notice] = "Data updated successfully"
      redirect_to "/profile" if current_user.default?
      redirect_to "/admin/users/#{@user.id}" if current_user.admin?
    else
      flash[:notice] = "Data not saved"
    end
  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
  end
end
