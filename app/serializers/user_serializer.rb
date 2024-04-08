class UserSerializer
  include JSONAPI::Serializer
  set_type :content

  attributes :email, :country
  attributes :createdAt do |object|
    object.created_at
  end
  
  attribute :updatedAt do |object|
      object.updated_at
  end
  has_many :contents

end
