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

  test 'gravatar_url uses uid as fallback for user without email' do
    user = User.new(email: nil, uid: '12345')
    url = gravatar_url(user)

    # MD5 hash of '12345'
    expected_hash = '827ccb0eea8a706c4c34a16891f84e7b'

    assert_equal "https://www.gravatar.com/avatar/#{expected_hash}?d=identicon&s=40", url
  end

  test 'gravatar_url uses anonymous for nil user' do
    url = gravatar_url(nil)

    # MD5 hash of 'anonymous'
    expected_hash = '294de3557d9d00b3d2d8a1e6aab028cf'

    assert_equal "https://www.gravatar.com/avatar/#{expected_hash}?d=identicon&s=40", url
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
