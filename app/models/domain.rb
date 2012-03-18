class Domain < ActiveRecord::Base
  attr_accessible :name
  has_many :emails

  default_scope order("name")
  
  validates :name, :presence => true, :format => { :with => /^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}$/i,
    :message => "%{value} has invalid format" }
end
