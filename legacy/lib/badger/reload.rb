module Badger
  def self.reload
    Badger.registry.clear
    Dir[Rails.root.join("app/models/badges/*.rb")].each do |file|
      require_dependency file
    end
  end
end
