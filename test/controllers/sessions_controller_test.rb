# frozen_string_literal: true

require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    OmniAuth.config.test_mode = true
  end

  teardown do
    OmniAuth.config.test_mode = false
    OmniAuth.config.mock_auth[:google_oauth2] = nil
    OmniAuth.config.mock_auth[:twitter2] = nil
    OmniAuth.config.mock_auth[:facebook] = nil
    OmniAuth.config.mock_auth[:discord] = nil
  end

  test 'should get login page' do
    get login_path

    assert_response :success
    assert_select 'h1', text: 'Login'
  end

  test 'should create user and login with google_oauth2' do
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
                                                                         provider: 'google_oauth2',
                                                                         uid: '123456',
                                                                         info: {
                                                                           name: 'Google User',
                                                                           email: 'google@example.com'
                                                                         }
                                                                       })

    assert_difference('User.count') do
      get '/auth/google_oauth2/callback'
    end

    assert_redirected_to root_path
    assert_equal 'Signed in!', flash[:notice]
    assert_equal User.last.id, session[:user_id]
    assert_equal 'Google User', User.last.name
  end

  test 'should create user and login with twitter' do
    OmniAuth.config.mock_auth[:twitter2] = OmniAuth::AuthHash.new({
                                                                    provider: 'twitter2',
                                                                    uid: '987654',
                                                                    info: {
                                                                      name: 'Twitter User',
                                                                      nickname: 'twitter_handle',
                                                                      email: 'twitter@example.com'
                                                                    }
                                                                  })

    assert_difference('User.count') do
      get '/auth/twitter2/callback'
    end

    assert_redirected_to root_path
    assert_equal 'Signed in!', flash[:notice]
    assert_equal User.last.id, session[:user_id]
    assert_equal 'twitter_handle', User.last.nickname
  end

  test 'should create user and login with facebook' do
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
                                                                    provider: 'facebook',
                                                                    uid: '555555',
                                                                    info: {
                                                                      name: 'Facebook User',
                                                                      email: 'facebook@example.com'
                                                                    }
                                                                  })

    assert_difference('User.count') do
      get '/auth/facebook/callback'
    end

    assert_redirected_to root_path
    assert_equal 'Signed in!', flash[:notice]
    assert_equal User.last.id, session[:user_id]
    assert_equal 'Facebook User', User.last.name
  end

  test 'should create user and login with discord' do
    OmniAuth.config.mock_auth[:discord] = OmniAuth::AuthHash.new({
                                                                   provider: 'discord',
                                                                   uid: '111111',
                                                                   info: {
                                                                     name: 'Discord User',
                                                                     email: 'discord@example.com'
                                                                   }
                                                                 })

    assert_difference('User.count') do
      get '/auth/discord/callback'
    end

    assert_redirected_to root_path
    assert_equal 'Signed in!', flash[:notice]
    assert_equal User.last.id, session[:user_id]
    assert_equal 'Discord User', User.last.name
  end
end
