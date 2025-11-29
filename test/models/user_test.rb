# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'display_name returns nickname if present' do
    user = User.new(nickname: 'CoolUser', name: 'John Doe', uid: '12345')

    assert_equal 'CoolUser', user.display_name
  end

  test 'display_name returns name as initials if nickname is blank' do
    user = User.new(nickname: '', name: 'John Doe', uid: '12345')

    assert_equal 'JD', user.display_name
  end

  test 'display_name handles single name' do
    user = User.new(nickname: '', name: 'Madonna', uid: '12345')

    assert_equal 'M', user.display_name
  end

  test 'display_name handles multiple names' do
    user = User.new(nickname: '', name: 'John Paul Jones', uid: '12345')

    assert_equal 'JPJ', user.display_name
  end

  test 'display_name returns uid if nickname and name are blank' do
    user = User.new(nickname: '', name: '', uid: '12345')

    assert_equal '12345', user.display_name
  end

  test 'nickname validation allows blank' do
    user = User.new(provider: 'github', uid: '12345', email: 'test@example.com', nickname: '')

    assert_predicate user, :valid?
  end

  test 'nickname validation enforces max length' do
    user = User.new(provider: 'github', uid: '12345', email: 'test@example.com', nickname: 'a' * 51)

    assert_not user.valid?
    assert_includes user.errors[:nickname], 'is too long (maximum is 50 characters)'
  end

  test 'nickname validation allows 50 characters' do
    user = User.new(provider: 'github', uid: '12345', email: 'test@example.com', nickname: 'a' * 50)

    assert_predicate user, :valid?
  end

  test 'can discard a user' do
    user = users(:ted)

    assert_not user.discarded?
    user.discard

    assert_predicate user, :discarded?
    assert_not_nil user.discarded_at
  end

  test 'can restore a discarded user' do
    user = users(:ted)
    user.discard

    assert_predicate user, :discarded?
    user.undiscard

    assert_not user.discarded?
    assert_nil user.discarded_at
  end

  test 'discarded user is excluded from default scope' do
    user = users(:ted)
    user.discard

    assert_not_includes User.kept, user
    assert_includes User.with_discarded, user
  end
end
