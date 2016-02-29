require 'rails_helper'

RSpec.describe BettingInfo, type: :model do
  it { is_expected.to belong_to :match }
  it { is_expected.to validate_presence_of :match }
end
