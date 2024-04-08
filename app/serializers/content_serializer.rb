class ContentSerializer
    include JSONAPI::Serializer
    set_type :content

    attributes :title, :body
    attributes :createdAt do |object|
        object.created_at
    end
    attribute :updatedAt do |object|
        object.updated_at
    end

    belongs_to :user
  

  end
  