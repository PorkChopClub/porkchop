class Api::TableController < ApplicationController
  skip_authorization_check
  skip_before_action :verify_authenticity_token
  before_action :check_table_token
  after_action :update_match_channel

  def home_button
    table.home_button
    head :ok
  end

  def away_button
    table.away_button
    head :ok
  end

  def center_button
    table.center_button
    head :ok
  end

  private

  def check_table_token
    unless params[:table_token] == ENV['TABLE_TOKEN']
      head :forbidden
    end
  end

  def table
    @table ||= PingPong::TableControls.new(ongoing_match)
  end
end
