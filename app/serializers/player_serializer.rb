class PlayerSerializer < ActiveModel::Serializer
  attributes :id,
             :nickname,
             :name
end
