class PlayerSerializer < ActiveModel::Serializer
  attributes :id,
             :nickname,
             :name,
             :avatar_url
end
