class User < ActiveRecord::Base
  def self.from_omniauth(omniauth)
    find_by_omniauth(omniauth) || create_from_omniauth(omniauth)
  end

  def self.find_by_omniauth(omniauth)
    User.find_by(
      provider: omniauth["provider"],
      uid: omniauth["uid"].to_s
    )
  end

  def self.create_from_omniauth(omniauth)
    create! do |user|
      user.provider = omniauth["provider"]
      user.uid = omniauth["uid"]

      if (info = omniauth["info"])
        user.username = info["nickname"] || info["name"]
      end
    end
  end
end
