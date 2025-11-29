# frozen_string_literal: true

module Avo
  module Concerns
    module SoftDeletableResource
      extend ActiveSupport::Concern

      # Override destroy to use soft deletion (discard) instead of hard delete
      def destroy
        @resource = resource_class.find(params[:id])
        @resource.discard!

        respond_to do |format|
          format.html { redirect_to resource_index_path, notice: t('avo.resources.destroy.success') }
          format.json { head :no_content }
        end
      rescue Discard::RecordNotDiscarded
        # Record is already discarded, treat as success
        respond_to do |format|
          format.html { redirect_to resource_index_path, notice: t('avo.resources.destroy.success') }
          format.json { head :no_content }
        end
      end

      private

      def resource_class
        self.class.name.demodulize.sub('Controller', '').singularize.constantize
      end

      # Must be implemented in each controller
      def resource_index_path
        raise NotImplementedError
      end
    end
  end
end
