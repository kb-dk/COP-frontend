class User < ActiveRecord::Base

  if Blacklight::Utils.needs_attr_accessible?
    attr_accessible :username, :password, :password_confirmation
  end

  # to allow guest users to be saved, we need to create a username
  before_validation do
    self.username = self.email if self.guest? && self.username.blank?
  end

  validates_uniqueness_of :username

  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #NKH devise :database_authenticatable, :registerable,
  #NKH       :recoverable, :rememberable, :trackable, :validatable
  devise :cas_authenticatable, :rememberable, :registerable

  # Method added by blacklight; blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    fullname
  end

  # the following two methods are necessary because devise-guests
  # has a dependency on database_authenticable which we are not using
  # because we use cas_authenticatable. So these methods just provide the API
  # expected by devise-guests without actually doing anything
  def password_confirmation=(*args)
  end

  def password=(*args)
  end

  # We use the fullname attribute rather than username because CAS auth expects
  # username to be the same one as used in the CAS login
  def cas_extra_attributes=(extra_attributes)
    unless self.persisted?
      self.fullname = "#{extra_attributes['gn']} #{extra_attributes['sn']}"
      self.email = extra_attributes['email']
    end
  end
end
