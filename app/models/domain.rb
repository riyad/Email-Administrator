class Domain < ActiveRecord::Base
  has_many :emails, :dependent => :destroy

  default_scope order("name")

  # access and validation

  attr_accessible :name

  # match IP or FQDN
  # see http://www.regular-expressions.info/regexbuddy/ipaccurate.html
  # see http://blog.gnukai.com/2010/06/fqdn-regular-expression/
  validates :name, :presence => true, :format => { :with => /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$|(?=^.{1,254}$)(^(?:(?!\d|-)[a-zA-Z0-9\-]{1,63}(?<!-)\.?)+(?:[a-zA-Z]{2,})$)/,
    :message => "%{value} is not an IP adress, a hostname or a FQDN" }
end
