require 'rails_helper'

RSpec.describe Api::MatchmakingsController, type: :controller do
  describe "GET show" do
    subject { get :show, format: :json }

    let!(:todd) do
      FactoryGirl.create(:player, name: "Todd Rundgren", active: true)
    end

    let!(:joe) do
      FactoryGirl.create(:player, name: "Joe Jackson", active: true)
    end

    let(:matchmaker) { instance_double Matchmaker }

    it { is_expected.to have_http_status :ok }

    it "returns a JSON representaion of the matchmaker's explanation" do
      allow(Matchmaker).to receive(:new).and_return(matchmaker)
      allow(matchmaker).to receive(:explain).and_return(probably: "reasons")

      expect(subject.body).to eq '{"probably":"reasons"}'
    end
  end
end
