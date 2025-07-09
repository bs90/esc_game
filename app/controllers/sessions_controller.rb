class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    user = User.find_or_create_by(id: auth.uid)
    session[:token] = "escmg_#{user.id}"
    redirect_to root_path
  end

  def destroy
    session[:token] = nil
    redirect_to root_path
  end
end
