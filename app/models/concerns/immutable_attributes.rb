# frozen_string_literal: true

module ImmutableAttributes
  extend ActiveSupport::Concern

  class_methods do
    # Makes specified attributes immutable after record creation
    # Usage: attr_immutable :slug, :uuid
    def attr_immutable(*attributes)
      # Mark attributes as readonly (prevents assignment after save)
      attr_readonly(*attributes)

      # Add validation to prevent changes with clear error messages
      attributes.each do |attribute|
        validate :"#{attribute}_cannot_be_changed", on: :update

        define_method :"#{attribute}_cannot_be_changed" do
          if send(:"#{attribute}_changed?") && persisted?
            errors.add(attribute, "cannot be changed once set")
          end
        end
        private :"#{attribute}_cannot_be_changed"
      end
    end
  end
end
