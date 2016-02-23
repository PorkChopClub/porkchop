require 'rails_helper'

RSpec.describe Api::TableController, type: :controller do
  let(:token) { 'm37410c41yp53' }
  let!(:match) { FactoryGirl.create :match }

  before do
    ENV['TABLE_TOKEN'] = 'm37410c41yp53'
  end

  shared_examples "without valid token" do
    context "when the table_token param is not valid" do
      let(:token) { 'wrongtoken' }
      it { is_expected.to have_http_status :forbidden }
    end
  end

  describe "#home_button" do
    subject do
      put :home_button, table_token: token
    end

    include_examples "without valid token"

    context "with a valid token" do
      let(:service) { instance_double PingPong::Service }

      before do
        expect(PingPong::Service).
          to receive(:new).
          and_return(service)

        expect(service).
          to receive(:record!)
      end

      it { is_expected.to have_http_status :ok }
    end
  end

  describe "#away_button" do
    subject do
      put :away_button, table_token: token
    end

    include_examples "without valid token"

    context "with a valid token" do
      let(:service) { instance_double PingPong::Service }

      before do
        expect(PingPong::Service).
          to receive(:new).
          and_return(service)

        expect(service).
          to receive(:record!)
      end

      it { is_expected.to have_http_status :ok }
    end
  end

  describe "#center_button" do
    subject do
      put :center_button, table_token: token
    end

    include_examples "without valid token"

    context "with a valid token" do
      let(:rewind) { instance_double PingPong::Rewind }

      before do
        expect(PingPong::Rewind).
          to receive(:new).
          and_return(rewind)

        expect(rewind).
          to receive(:rewind!)
      end

      it { is_expected.to have_http_status :ok }
    end
  end
end
