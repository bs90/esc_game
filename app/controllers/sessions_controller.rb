class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    user = User.find_or_initialize_by(id: auth.uid)
    email = auth.info.email.to_s.strip.downcase
    name_from_email = email.split("@").first.to_s.strip

    user.email = email if user.respond_to?(:email=) && email.present?
    user.name = name_from_email if user.respond_to?(:name=) && name_from_email.present?
    user.save!

    session[:token] = "escmg_#{user.id}"
    redirect_to root_path
  end

  def destroy
    session[:token] = nil
    redirect_to root_path
  end
end
