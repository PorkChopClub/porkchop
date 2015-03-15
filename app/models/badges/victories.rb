Badger.define do
  badge :victories do
    ranks [1, 5, 10, 25, 50, 100, 250, 500, 1000]
    condition do |player|
      player.victories.size >= 1
    end
    calculate_rank do |player|
      num_victories = player.victories.size
      ranks.rindex{ |r| num_victories >= r }
    end
  end
end
