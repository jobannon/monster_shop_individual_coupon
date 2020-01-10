class SessionsController < ApplicationController
  def new
    user_redirect(current_user) if current_user
  end

  def create
    user = User.find_by(email: params[:email])
    if !user.active?
      flash[:sad] = "Account is Disabled"
      render :new
    elsif user && user.authenticate(params[:password])
      user_redirect(user)
      session[:user_id] = user.id
      flash[:happy] = "Welcome, #{user.name}!"
    else
      flash[:sad] = 'Credentials were incorrect'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    session[:cart] = nil
    redirect_to '/'
    flash[:happy] = 'Goodbye!'
  end

  def show
    render '/errors/404' unless current_user
    @user = User.find(session[:user_id]) if current_user
  end
end
