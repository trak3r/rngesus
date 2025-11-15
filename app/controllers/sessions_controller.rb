# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    auth = request.env['omniauth.auth']

    # 1. Find or create a User
    user = User.find_or_initialize_by(provider: auth.provider, uid: auth.uid)
    user.name  = auth.info.name
    user.email = auth.info.email
    user.save!

    # 2. Store the user in the session
    session[:user_id] = user.id

    # 3. Redirect to your app
    redirect_to root_path, notice: t('flash.signed_in')
  end

  def destroy
    reset_session # wipes the whole session securely
    redirect_to root_path, notice: t('flash.signed_out')
  end
end
