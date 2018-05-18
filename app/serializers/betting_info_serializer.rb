class BettingInfoSerializer < ActiveModel::Serializer
  attributes :spread

  def spread
    [object.favourite.name, object.spread].join(" ")
  end
end
