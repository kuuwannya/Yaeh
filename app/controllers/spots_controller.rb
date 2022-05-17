class SpotsController < ApplicationController
  before_action :require_login
  before_action :spot_find, only: %i[show edit update destroy]

  def index
    @spots = Spot.all.includes(:user).order(created_at: :desc)
  end

  def show
    gon.center_of_map_lat = @spot.latitude
    gon.center_of_map_lng = @spot.longitude
    gon.zoom_level_of_map = 17
    gon.spots_on_map = Spot.all
    gon.spot_lat = @spot.latitude
    gon.spot_lng = @spot.longitude
    gon.spot_id = @spot.id
  end

  def new
    @spot = Spot.new
  end

  def create
    @spot = current_user.spots.new(spot_params)
    if @spot.save
      redirect_to spots_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @spot.update(spot_params)
      redirect_to spot_path(@spot)
    else
      render :edit
    end

  end

  private
  def spot_params
    params.require(:spot).permit(:name, :address, :spot_parking, :spot_parking_price)
  end

  def spot_find
      @spot = Spot.find(params[:id])
    end
end