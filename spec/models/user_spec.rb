require 'rails_helper'

RSpec.describe User, type: :model do
  describe ".from_omniauth" do
    subject { described_class.from_omniauth omniauth }

    let(:omniauth) do
      {
        "provider" => "twitter",
        "uid" => "1234567890",
        "info" => {
          "nickname" => "candicebergenfan"
        }
      }
    end

    context "when the user exists" do
      let!(:user) do
        FactoryGirl.create :user,
          provider: "twitter",
          uid: "1234567890"
      end

      it { is_expected.to eq user }
    end

    context "when the user doesn't exist" do
      it "creates a user" do
        expect{subject}.
          to change{User.count}.
          from(0).to(1)
      end

      it "saves the user's info" do
        subject
        user = User.first
        expect(user.provider).to eq "twitter"
        expect(user.uid).to eq "1234567890"
        expect(user.username).to eq "candicebergenfan"
      end
    end
  end
end
