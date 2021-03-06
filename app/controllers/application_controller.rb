class ApplicationController < ActionController::Base

  include CanCan::ControllerAdditions

  # for side_bar information
  def get_categories
    @sd_categories = Category.all
  end
  helper_method :get_categories

  def get_category_post_count(cat)
    @sd_posts = Post.where(category_id: cat).count
  end
  helper_method :get_category_post_count

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_user
    # check if current user is signed in
    redirect_to new_session_path, alert: "Please sign in!" unless user_signed_in?
  end

  # check if current_user exist in the sessions and assign it in the global
  # variable @current_user that will be used  in controller
  def current_user
    @current_user ||= User.find_by_id session[:user_id] if session[:user_id]
  end
  # this will make this method accessible to views
  helper_method :current_user

  def user_signed_in?
    # check if current user is signed in
    current_user.present?
  end
  helper_method :user_signed_in?

end
