# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :require_login

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    
    if @user.update(user_params)
      redirect_to edit_user_path, notice: 'Settings updated successfully.'
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def user_params
    params.expect(user: [:nickname])
  end
end
