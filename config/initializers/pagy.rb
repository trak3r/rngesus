# frozen_string_literal: true

require 'pagy/extras/overflow'
require 'pagy/extras/bootstrap'

# Set default items per page
# Pagy v9 renames :items to :limit
Pagy::DEFAULT[:limit] = 6
Pagy::DEFAULT[:overflow] = :last_page
