# frozen_string_literal: true

class RandomizersController < ApplicationController
  before_action :require_login, except: %i[index show]
  before_action :set_randomizer, except: %i[index new create]
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
    @randomizers = Randomizer.search(params[:query]).all
  end

  # GET /randomizers/1
  def show; end

  # GET /randomizers/new
  def new
    # @randomizer = Randomizer.new
    @randomizer = current_user.randomizers.build
  end

  # GET /randomizers/1/edit
  def edit; end

  # POST /randomizers
  def create
    # @randomizer = Randomizer.new(randomizer_params)
    @randomizer = current_user.randomizers.build(randomizer_params)

    if @randomizer.save
      redirect_to @randomizer,
                  notice: t('.success')
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /randomizers/1
  def update
    if @randomizer.update(randomizer_params)
      redirect_to @randomizer,
                  notice: t('randomizers.create.success'),
                  status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /randomizers/1
  def destroy
    @randomizer.destroy!
    redirect_to randomizers_path,
                notice: t('randomizers.create.success'),
                status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_randomizer
    @randomizer = Randomizer.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def randomizer_params
    params.expect(randomizer: [:name])
  end

  def check_ownership
    unless @randomizer.user == current_user
      redirect_to randomizers_path, alert: "You don't have permission to do that."
    end
  end
end
