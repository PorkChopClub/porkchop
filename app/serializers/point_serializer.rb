class PointSerializer < ActiveModel::Serializer
  belongs_to :match
  belongs_to :victor
end
