require 'rails_helper'

RSpec.describe SeasonMatch, type: :model do
  it { is_expected.to belong_to(:match) }
  it { is_expected.to belong_to(:season) }
end
