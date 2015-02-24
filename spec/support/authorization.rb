RSpec.shared_context "controller authorization" do
  let(:ability) do
    Object.new.tap do |ability|
      ability.extend CanCan::Ability
    end
  end

  before do
    allow(controller).
      to receive(:current_ability).
      and_return(ability)
  end
end
