require 'rails_helper'

RSpec.describe Point, type: :model do
  it { is_expected.to belong_to :match }
  it { is_expected.to belong_to :victor }
end
