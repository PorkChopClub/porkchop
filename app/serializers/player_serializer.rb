class PlayerSerializer < ActiveModel::Serializer
  attributes :id,
             :nickname,
             :name

  attribute :legacy_avatar_url, key: :avatar_url
end
