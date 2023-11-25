class UserSerializer < ActiveModel::Serializer
  attributes :email,:name
  has_many :posts

end
