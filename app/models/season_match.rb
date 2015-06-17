class SeasonMatch < ActiveRecord::Base
  belongs_to :match
  belongs_to :season
end
