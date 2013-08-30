class Apid < ActiveRecord::Base
  attr_accessible :value

  belongs_to :driver
end
