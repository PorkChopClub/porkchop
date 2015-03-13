require 'rails_helper'

RSpec.describe Achievement, type: :model do
  it { is_expected.to belong_to :player }
end
