# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:ted)
  end

  test 'should redirect to login when not authenticated' do
    get edit_user_url
    assert_redirected_to '/login'
  end

  test 'should get edit when authenticated' do
    UsersController.any_instance.stubs(:current_user).returns(@user)
    get edit_user_url
    assert_response :success
  end

  test 'should update nickname' do
    UsersController.any_instance.stubs(:current_user).returns(@user)
    patch user_url, params: { user: { nickname: 'NewNickname' } }
    assert_redirected_to edit_user_path
    @user.reload
    assert_equal 'NewNickname', @user.nickname
  end

  test 'should reject nickname longer than 50 characters' do
    UsersController.any_instance.stubs(:current_user).returns(@user)
    patch user_url, params: { user: { nickname: 'a' * 51 } }
    assert_response :unprocessable_content
  end

  test 'should allow clearing nickname' do
    UsersController.any_instance.stubs(:current_user).returns(@user)
    @user.update(nickname: 'OldNickname')
    
    patch user_url, params: { user: { nickname: '' } }
    assert_redirected_to edit_user_path
    @user.reload
    assert @user.nickname.blank?
  end
end
