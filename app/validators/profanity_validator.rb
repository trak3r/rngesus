# frozen_string_literal: true

# Custom validator to check for profanity using LanguageFilter gem
class ProfanityValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    filter = LanguageFilter::Filter.new(matchlist: :profanity)
    
    return unless filter.match?(value)

    matched_words = filter.matched(value).join(', ')
    record.errors.add(attribute, "contains inappropriate language: #{matched_words}")
  end
end
