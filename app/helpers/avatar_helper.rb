# frozen_string_literal: true

require 'digest/md5'

module AvatarHelper
  # Generate a Gravatar URL for the given user
  # @param user [User] the user object
  # @param size [Integer] the size of the avatar in pixels (default: 40)
  # @return [String] the Gravatar URL
  def gravatar_url(user, size: 40)
    return nil unless user&.email.present?

    # Gravatar requires lowercase, trimmed email
    email_hash = Digest::MD5.hexdigest(user.email.downcase.strip)
    
    # d=identicon generates a unique geometric pattern as fallback
    # s=size sets the image size
    "https://www.gravatar.com/avatar/#{email_hash}?d=identicon&s=#{size}"
  end
end
