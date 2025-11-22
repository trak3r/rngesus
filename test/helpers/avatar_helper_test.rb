# frozen_string_literal: true

require 'test_helper'

class AvatarHelperTest < ActionView::TestCase
  test 'gravatar_url generates correct URL for user with email' do
    user = User.new(email: 'test@example.com')
    url = gravatar_url(user)
    
    # MD5 hash of 'test@example.com'
    expected_hash = '55502f40dc8b7c769880b10874abc9d0'
    assert_equal "https://www.gravatar.com/avatar/#{expected_hash}?d=identicon&s=40", url
  end

  test 'gravatar_url handles email with uppercase and whitespace' do
    user = User.new(email: '  TEST@EXAMPLE.COM  ')
    url = gravatar_url(user)
    
    # Should normalize to lowercase and trim
    expected_hash = '55502f40dc8b7c769880b10874abc9d0'
    assert_equal "https://www.gravatar.com/avatar/#{expected_hash}?d=identicon&s=40", url
  end

  test 'gravatar_url accepts custom size parameter' do
    user = User.new(email: 'test@example.com')
    url = gravatar_url(user, size: 80)
    
    assert_includes url, 's=80'
  end

  test 'gravatar_url returns nil for user without email' do
    user = User.new(email: nil)
    assert_nil gravatar_url(user)
  end

  test 'gravatar_url returns nil for nil user' do
    assert_nil gravatar_url(nil)
  end

  test 'gravatar_profile_url generates correct profile URL' do
    user = User.new(email: 'test@example.com')
    url = gravatar_profile_url(user)
    
    # MD5 hash of 'test@example.com'
    expected_hash = '55502f40dc8b7c769880b10874abc9d0'
    assert_equal "https://www.gravatar.com/#{expected_hash}", url
  end

  test 'gravatar_profile_url handles email normalization' do
    user = User.new(email: '  TEST@EXAMPLE.COM  ')
    url = gravatar_profile_url(user)
    
    # Should normalize to lowercase and trim
    expected_hash = '55502f40dc8b7c769880b10874abc9d0'
    assert_equal "https://www.gravatar.com/#{expected_hash}", url
  end

  test 'gravatar_profile_url returns nil for user without email' do
    user = User.new(email: nil)
    assert_nil gravatar_profile_url(user)
  end

  test 'gravatar_profile_url returns nil for nil user' do
    assert_nil gravatar_profile_url(nil)
  end
end
