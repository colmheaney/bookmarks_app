class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :bookmarks
  has_many :posts

  attr_accessor :signin

  validates :username, :uniqueness => { :case_sensitive => false }


  devise :database_authenticatable, :registerable,
         :rememberable, :validatable, :recoverable, :confirmable#, :trackable

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if signin = conditions.delete(:signin)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => signin.downcase }]).first
    else
      where(conditions).first
    end
  end
  
end
