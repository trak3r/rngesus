# frozen_string_literal: true

class RandomizersController < ApplicationController
  before_action :require_login, except: %i[index show]
  before_action :set_randomizer, except: %i[index new create choose_method create_with_upload]
  before_action :check_ownership, only: %i[edit update destroy]

  # the old man CRUD soul in me thinks this should be in
  # RandomizerLikesController.create/destroy
  def toggle_like
    if current_user.voted_for?(@randomizer)
      @randomizer.unliked_by current_user
    else
      @randomizer.liked_by current_user
    end

    respond_to do |format|
      format.turbo_stream
      # format.html { redirect_to @randomizer }
    end
  end

  # GET /randomizers
  def index
    @tab = params[:tab] || 'most_liked'

    # Handle both :tags (array) and legacy :tag (string)
    @tags = Array(params[:tags])
    @tags << params[:tag] if params[:tag].present?
    @tags = @tags.compact_blank.uniq

    # Redirect to login for user-specific tabs if not authenticated
    redirect_to '/login' and return if %w[your_likes your_randomizers].include?(@tab) && !current_user

    # Query based on active tab
    @randomizers = case @tab
                   when 'newest'
                     Randomizer.search(params[:query]).tagged_with(@tags).newest
                   when 'most_liked'
                     Randomizer.search(params[:query]).tagged_with(@tags).where('cached_votes_total > 0').most_liked
                   when 'your_likes'
                     current_user.get_voted(Randomizer).search(params[:query]).tagged_with(@tags).newest
                   when 'your_randomizers'
                     current_user.randomizers.search(params[:query]).tagged_with(@tags).newest
                   else # rubocop:disable Lint/DuplicateBranch
                     Randomizer.search(params[:query]).tagged_with(@tags).where('cached_votes_total > 0').most_liked
                   end
  end

  # GET /randomizers/1
  def show; end

  # GET /randomizers/new/choose_method
  def choose_method
    # Wizard step 1: choose creation method
  end

  # POST /randomizers/create_with_upload
  def create_with_upload
    # Create a dummy randomizer and roll for upload flow
    @randomizer = current_user.randomizers.build(name: 'New Randomizer')
    @roll = @randomizer.rolls.build(name: 'New Roll', dice: 'D20')

    if @randomizer.save
      # Redirect to upload page (step 1.5)
      redirect_to new_roll_results_img_path(@roll)
    else
      # If save fails, go back to choose method
      redirect_to choose_method_randomizers_path, alert: t('.create_failed')
    end
  end

  # GET /randomizers/new
  def new
    @method = params[:method] || 'manual' # 'upload' or 'manual'

    if params[:upload_randomizer_id].present?
      # Load the existing randomizer created for upload flow
      @randomizer = current_user.randomizers.find(params[:upload_randomizer_id])
    else
      # Build new randomizer for manual flow
      @randomizer = current_user.randomizers.build
      # Build nested roll with 3 empty results for manual entry
      roll = @randomizer.rolls.build
      3.times { roll.results.build } if @method == 'manual'
    end
  end

  # GET /randomizers/1/edit
  def edit; end

  # POST /randomizers
  def create
    @randomizer = current_user.randomizers.build(randomizer_params)

    if @randomizer.save
      redirect_to randomizer_outcomes_path(@randomizer),
                  notice: t('.success')
    else
      @method = params[:randomizer][:method] || 'manual'
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /randomizers/1
  def update
    # Extract method parameter (not a model attribute) before permitting params
    @method = params[:randomizer][:method] if params[:randomizer][:method].present?

    if @randomizer.update(randomizer_params)
      redirect_to @randomizer,
                  notice: t('.success'),
                  status: :see_other
    elsif @method.present?
      # If this came from wizard flow, render wizard
      render :new, status: :unprocessable_content
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /randomizers/1
  def destroy
    if @randomizer.discarded?
      return redirect_to randomizers_path(tab: params[:tab]),
                         notice: t('.success'),
                         status: :see_other
    end

    @randomizer.discard
    redirect_to randomizers_path(tab: params[:tab]),
                notice: t('.success'),
                status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_randomizer
    @randomizer = Randomizer.find_by!(slug: params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def randomizer_params
    params.expect(
      randomizer: [:name,
                   { tag_ids: [],
                     rolls_attributes: [
                       :id,
                       :name,
                       :dice,
                       :_destroy,
                       { results_attributes: %i[
                         id
                         name
                         value
                         _destroy
                       ] }
                     ] }]
    )
  end

  def check_ownership
    return if @randomizer.user == current_user

    redirect_to randomizers_path, alert: t('errors.unauthorized')
  end
end
