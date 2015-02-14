require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "GET index" do
    subject { get :index }

    specify { expect(subject.status).to eq 200 }
    it { is_expected.to render_template :index }
  end
end
