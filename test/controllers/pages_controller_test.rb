# frozen_string_literal: true

require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get terms page' do
    get terms_url

    assert_response :success
    assert_select 'h1', text: 'Terms of Service'
  end

  test 'should get privacy page' do
    get privacy_url

    assert_response :success
    assert_select 'h1', text: 'Privacy Policy'
  end

  test 'should get dmca page' do
    get dmca_url

    assert_response :success
    assert_select 'h1', text: 'DMCA / Copyright Policy'
  end
end
