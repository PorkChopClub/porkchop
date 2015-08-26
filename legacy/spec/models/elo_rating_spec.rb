require 'rails_helper'

RSpec.describe EloRating, type: :model do
  it { is_expected.to validate_presence_of :player }
  it { is_expected.to validate_presence_of :rating }
  it { is_expected.to belong_to :player }

  describe ".most_recent_rating" do
    let!(:elo) { FactoryGirl.create :elo_rating, rating: 2500 }
    subject { EloRating.most_recent_rating }
    it { is_expected.to eq 2500 }
  end
end
