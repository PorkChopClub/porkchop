require 'rails_helper'

RSpec.describe Stats::Streak do
  it { is_expected.to belong_to :player }

  it { is_expected.to validate_presence_of :streak_type }
  it { is_expected.to validate_presence_of :streak_length }

  it "is either a winning streak or losing streak" do
    is_expected.to validate_inclusion_of(:streak_type).
                     in_array(%w[W L])
  end
end
