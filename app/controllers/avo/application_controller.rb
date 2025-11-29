# frozen_string_literal: true

module Avo
  class ApplicationController < Avo::BaseApplicationController
    def current_user
      return @current_user if defined?(@current_user)

      @current_user = User.find_by(id: session[:user_id])
    end
    helper_method :current_user
  end
end
