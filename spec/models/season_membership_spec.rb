require 'rails_helper'

RSpec.describe SeasonMembership, type: :model do
  it { is_expected.to belong_to(:player) }
  it { is_expected.to belong_to(:season) }
end
