require "test_helper"

class Avo::HomeControllerTest < ActionDispatch::IntegrationTest
  test "should redirect guest to root" do
    get "/avo"
    assert_redirected_to "/"
    follow_redirect!
    assert_equal "You must be logged in to access the admin panel.", flash[:alert]
  end

  test "should redirect non-admin user to root" do
    user = users(:other_user)
    login_as(user)
    
    get "/avo"
    assert_redirected_to "/"
    follow_redirect!
    assert_equal "You don't have permission to access the admin panel.", flash[:alert]
  end

  test "should allow admin user" do
    user = users(:ted)
    # Ensure the user has the correct admin credentials
    user.update!(provider: 'google_oauth2', uid: '105389714176102520548')
    login_as(user)

    get "/avo/"
    follow_redirect!
    assert_response :success
  end
end
