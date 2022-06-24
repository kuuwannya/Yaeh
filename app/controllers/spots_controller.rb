class SpotsController < ApplicationController
  before_action :spot_find, only: %i[show edit update destroy]
  skip_before_action :require_login, only: %i[index show]
  skip_before_action :verify_authenticity_token

  def index
    @spots = Spot.all.includes(:user).order(created_at: :desc)
  end

  def show
    @spot = Spot.find(params[:id])
    @longitude = @spot.longitude
    @latitude = @spot.latitude
    @posts = @spot.posts.first(5)
  end

  def new
    @spot = Spot.new
    @spot.name = params[:name]
    @spot.address = params[:address]
    @spot.place_id = params[:place_id]
    @spot.latitude = params[:latitude]
    @spot.longitude = params[:longitude]
  end

  def create
    @spot = current_user.spots.new(spot_params)
    if @spot.save
      redirect_to spots_path, success: t('.success')
    else
      flash.now['danger'] = t('.fail')
      render :new
    end
  end

  def edit; end

  def update
    if @spot.update(spot_params)
      redirect_to spot_path(@spot), success: t('.success')
    else
      flash.now['danger'] = t('.fail')
      render :edit
    end
  end

  def destroy
    @spot.destroy!
    redirect_to spots_path, success: t('.success')
  end

  private
  def spot_params
    params.require(:spot).permit(:name, :address, :place_id, :latitude, :longitude, :prefecture)
  end

  def spot_find
      @spot = Spot.find(params[:id])
  end
end
