class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_filter :authenticate_user!

  def github
    p env["omniauth.auth"]
    github_profile = User.from_omniauth(env["omniauth.auth"], current_user)

    if github_profile.persisted?
      redirect_to github_profile_create_path(github_username: github_profile.username)
    else
      redirect_to profile_path(current_user.username)
    end
  end

  def linkedin
    p env["omniauth.auth"]
    linkedin_profile = User.create_linkedin(env["omniauth.auth"], current_user)

    if linkedin_profile.persisted?
      redirect_to linkedin_profile_create_path(:linkedin_profile_id => linkedin_profile.id)
    else
      redirect_to profile_path(current_user.username)
    end
  end

end
