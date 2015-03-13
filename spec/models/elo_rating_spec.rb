require 'rails_helper'

RSpec.describe EloRating, type: :model do
  it { is_expected.to validate_presence_of :player }
  it { is_expected.to validate_presence_of :rating }
  it { is_expected.to belong_to :player }
end
