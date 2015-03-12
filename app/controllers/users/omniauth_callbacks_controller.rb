class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_filter :authenticate_user!

  def github
    p env["omniauth.auth"]
    github_profile = User.from_omniauth(env["omniauth.auth"], current_user)

    if github_profile.persisted?
      redirect_to github_profile_create_path(github_username: github_profile.username)
    else
      session["devise.user_attributes"] = @user.attributes
      redirect_to new_user_registration_url
    end
  end

end
