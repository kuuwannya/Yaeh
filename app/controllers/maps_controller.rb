class MapsController < ApplicationController
  def search
    search_radius = 60
    default_lat = 35.6811673
    default_lng = 139.7670516
    gon.center_of_map_lat = 35.6811673
    gon.center_of_map_lng = 139.7670516
    gon.zoom_level_of_map = 13
    gon.spots_on_map = Spot.all

    if params[:q]
      @latitude = geo_params[:latitude].to_f
      @longitude = geo_params[:longitude].to_f
      @spots = Spot.all.within(search_radius, origin: [@latitude, @longitude]).by_distance(origin: [@latitude, @longitude])
      @area = search_area(@latitude, @longitude)
      gon.latitude = @latitude
      gon.longitude = @longitude
      gon.spots = @spots
    else
      gon.latitude = default_lat
      gon.longitude = default_lng
    end
  end

  def user
    search_radius = 1.5
    default_lat = 35.6811673
    default_lng = 139.7670516
    if params[:q]
      @latitude = geo_params[:latitude].to_f
      @longitude = geo_params[:longitude].to_f
      @jiros = Jiro.all.within(search_radius, origin: [@latitude, @longitude]).by_distance(origin: [@latitude, @longitude])
      @saunas = Sauna.all.within(search_radius, origin: [@latitude, @longitude]).by_distance(origin: [@latitude, @longitude])
      gon.latitude = @latitude
      gon.longitude = @longitude
      gon.jiros = @jiros
      gon.saunas = @saunas
    else
      gon.latitude = default_lat
      gon.longitude = default_lng
    end
  end

  private

  def geo_params
    params.require(:q).permit(:latitude, :longitude)
  end

  def search_area(lat, long)
    geoapi_url = "https://geoapi.heartrails.com/api/json?method=searchByGeoLocation&x=#{long}&y=#{lat}"
    #geoapi_page = URI.open(geoapi_url).read
    #geoapi_data = JSON.parse(geoapi_page)
    #prefecture = geoapi_data['response']['location'][0]['prefecture']
    #city = geoapi_data['response']['location'][0]['city']
    #town = geoapi_data['response']['location'][0]['town']

    #"#{prefecture}#{city}#{town}"
  end

end
