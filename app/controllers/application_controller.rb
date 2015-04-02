class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  before_filter :update_sanitized_params_signup, if: :devise_controller?
  before_filter :update_sanitized_params_edit, if: :devise_controller?


	def update_sanitized_params_signup
		devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:email, :password, :password_confirmation, :full_name, :username, :gender)}
	end

	def update_sanitized_params_edit
		devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:email, :password, :password_confirmation, :current_password, :full_name, :username, :gender, :short_bio, :availability)}
	end
end
