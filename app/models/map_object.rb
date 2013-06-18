#
# A MapObject is a POI in a map.
#
class MapObject < ActiveRecord::Base

  attr_accessible :category, :expire_date, :latitude, :longitude, :expirable

  #
  # Constructs a MapObject. Params are: 
  # category: the category of the map object. Please refer to MapObject::Categories
  # for a list of supported categories
  # latitude: the latitude of the map object
  # longitude: the longitude of tha map object
  # expire_in: the number of seconds that the map object will last before being expirable. 
  # If = 0 or not specified, the MapObject will not have an expiration date
  #
  def MapObject.construct(category, latitude, longitude, expire_in = 0)
    map_object = MapObject.new()
    map_object.category = category
    map_object.latitude = latitude
    map_object.longitude = longitude
    map_object.expire_date = (-expire_in).seconds.ago
    map_object.expirable = true
    if expire_in == 0
      map_object.expirable = false
    end

    return map_object
  end

  #
  # Returns true if a given map object es expirable and has expired.
  #
  def is_expired?
    expirable && Time.now >= expire_date
  end

  #
  # Expires a MapObject. If unexpirable, throws an ExpireError. If it has not yet expired
  # it will also throw a ExpireError
  #
  def expire
    if is_expired?
      self.destroy

    elsif expirable && Time.now < expire_date
      raise ExpireError, 'this map object has not yet expired. It will expire in '+expire_date.to_s
    else
      raise ExpireError, 'this map object is not expirable'
    end
  end

  #
  # Returns all the map objects by a specific category, even if they are expired.
  # For a list of all unexpired objects use MapObject.get_unexpired
  #
  def MapObject.get_by_category(category)

    MapObject.find_all_by_category(category)

  end

  #
  # Returns all unxpired objects
  #
  def MapObject.get_unexpired
    MapObject.where('expirable = :expirable OR expire_date >= :expire_date',{:expirable=>false, :expire_date=>Time.now})
  end


  #
  # Returns all the MapObjects that have not expired, filtering by a scpecified category
  #
  def MapObject.get_unexpired_by_category(category)
    MapObject.where('(expirable = :expirable OR expire_date >= :expire_date) AND category = :category',{:expirable=>false, :expire_date=>Time.now, :category => category})
  end

  # Categories is basically an enum of all possible (recognizable)
  module Categories

    GAS_STATION = 'gas station'
    ACCIDENT = 'accident'
    TRAFFIC_SLOW = 'slow traffic'
    TRAFFIC_FAST = 'fast traffic'
    POLICE = 'police'
    ALL = [GAS_STATION, ACCIDENT, TRAFFIC_SLOW, TRAFFIC_FAST, POLICE]

  end

  #
  # This error is raised if an attempt is made to expire an unexpirable object
  # or to an object that is expirable but has not yet expired
  #
  class ExpireError < ArgumentError
  end
  

end
