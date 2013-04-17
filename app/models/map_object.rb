class MapObject < ActiveRecord::Base
  attr_accessible :category, :description, :latitude, :longitude


  def MapObject.construct(category, latitude, longitude, description="")
    map_object = MapObject.new()
    map_object.category = category
    map_object.latitude = latitude
    map_object.longitude = longitude
    map_object.description = description
    return map_object
  end


  def MapObject.get_by_category(category)

    MapObject.find_all_by_category(category)

  end

  def MapObject.hueco
    "hueco"
  end

  def MapObject.trancon
    "trancon"
  end

  def MapObject.camara
    "camara"
  end





end
