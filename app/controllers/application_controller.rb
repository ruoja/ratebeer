class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
  	return nil if session[:user_id].nil?
  	User.find(session[:user_id])
  end

  def ensure_that_signed_in
  	redirect_to signin_path, notice:'you should be signed in' if current_user.nil?
  end

  def check_admin_rights
    redirect_to :back, notice:'you need admin rights to perform this operation' if current_user.admin == false
  end

  def top(n, category)
    last = n - 1
    sorted_by_rating_in_desc_order = category.all.sort_by{ |item| -(item.average_rating||0) }
    sorted_by_rating_in_desc_order[0..last]
  end

end
