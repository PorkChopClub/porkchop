class Point < ActiveRecord::Base
  belongs_to :match
  belongs_to :victor, class_name: "Player"
end
