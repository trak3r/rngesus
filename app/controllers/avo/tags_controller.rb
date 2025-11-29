# frozen_string_literal: true

# This controller has been generated to enable Rails' resource routes.
# More information on https://docs.avohq.io/3.0/controllers.html
module Avo
  class TagsController < Avo::ResourcesController
    # Override destroy to use soft deletion (discard) instead of hard delete
    # This ensures records are never permanently deleted, only soft-deleted
    def destroy
      @resource = Tag.find(params[:id])
      @resource.discard!

      respond_to do |format|
        format.html { redirect_to avo.resources_tags_path, notice: t('avo.resources.destroy.success') }
        format.json { head :no_content }
      end
    rescue Discard::RecordNotDiscarded
      # Record is already discarded, treat as success
      respond_to do |format|
        format.html { redirect_to avo.resources_tags_path, notice: t('avo.resources.destroy.success') }
        format.json { head :no_content }
      end
    end
  end
end
