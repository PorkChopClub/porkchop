class Point < ActiveRecord::Base
  belongs_to :match, touch: true
  belongs_to :victor, class_name: "Player"
end
