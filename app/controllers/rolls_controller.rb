# frozen_string_literal: true

class RollsController < ApplicationController
  before_action :require_login, except: %i[index show reroll]
  before_action :set_roll, only: %i[show edit update destroy toggle_like reroll edit_name]
  before_action :check_ownership, only: %i[edit update destroy edit_name]

  def toggle_like
    if current_user.voted_for?(@roll)
      @roll.unliked_by current_user
    else
      @roll.liked_by current_user
    end

    respond_to do |format|
      format.turbo_stream
    end
  end

  # GET /rolls
  def index
    @tab = params[:tab] || 'most_liked'
    @tags = Array(params[:tags])
    @tags << params[:tag] if params[:tag].present?
    @tags = @tags.compact_blank.uniq

    redirect_to '/login' and return if %w[your_likes your_rolls].include?(@tab) && !current_user

    @rolls = case @tab
             when 'newest'
               Roll.search(params[:query]).tagged_with(@tags).newest
             when 'most_liked'
               Roll.search(params[:query]).tagged_with(@tags).where('cached_votes_total > 0').most_liked
             when 'your_likes'
               current_user.get_voted(Roll).search(params[:query]).tagged_with(@tags).newest
             when 'your_rolls'
               current_user.rolls.search(params[:query]).tagged_with(@tags).newest
             end || Roll.search(params[:query]).tagged_with(@tags).where('cached_votes_total > 0').most_liked
  end

  # GET /rolls/1
  def show
    # Acts as the "Outcome" page (rolling the dice)
    @rolled, @result = @roll.outcome
  end

  # POST /rolls/1/reroll
  def reroll
    @rolled, @result = @roll.outcome

    respond_to do |format|
      format.turbo_stream
    end
  end

  # GET /rolls/new/choose_method
  def choose_method
    # Wizard step 1
  end

  # POST /rolls/create_with_upload
  def create_with_upload
    @roll = current_user.rolls.build(name: 'New Roll', dice: 'D20')

    if @roll.save
      redirect_to new_roll_results_img_path(@roll)
    else
      redirect_to choose_method_rolls_path, alert: t('.create_failed')
    end
  end

  # GET /rolls/new
  def new
    @method = params[:method] || 'manual'

    if params[:upload_roll_id].present?
      @roll = current_user.rolls.find(params[:upload_roll_id])
    else
      @roll = current_user.rolls.build
      3.times { @roll.results.build } if @method == 'manual'
    end
  end

  # GET /rolls/1/edit
  def edit; end

  # GET /rolls/1/edit_name
  def edit_name; end

  # POST /rolls
  def create
    @roll = current_user.rolls.build(roll_params)

    if @roll.save
      redirect_to @roll, notice: t('.success')
    else
      @method = params[:roll][:method] || 'manual'
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /rolls/1
  def update
    @method = params[:roll][:method] if params[:roll][:method].present?

    if @roll.update(roll_params)
      redirect_to @roll, notice: t('.success'), status: :see_other
    elsif @method.present?
      render :new, status: :unprocessable_content
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /rolls/1
  def destroy
    return redirect_to rolls_path(tab: params[:tab]), notice: t('.success'), status: :see_other if @roll.discarded?

    @roll.discard
    redirect_to rolls_path(tab: params[:tab]), notice: t('.success'), status: :see_other
  end

  private

  def set_roll
    @roll = Roll.find_by!(slug: params[:id])
  end

  def roll_params
    params.require(:roll).permit(
      :name,
      :dice,
      { tag_ids: [] },
      results_attributes: %i[id name value _destroy]
    )
  end

  def check_ownership
    return if @roll.user == current_user

    redirect_to rolls_path, alert: t('errors.unauthorized')
  end
end
