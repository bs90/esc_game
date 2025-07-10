class HomeController < ApplicationController
  def index
    if current_user
      @qr_url = "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=https://sunesc.heasygame.online/touch/#{current_user.id}"
    end
  end

  def touch
    return redirect_to root_path unless current_user
    return redirect_to root_path unless touched_user = User.find_by_id(params[:id])
    Touch.create_touch! current_user, touched_user
    redirect_to root_path
  end
end
