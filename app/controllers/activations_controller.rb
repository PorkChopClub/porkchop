class ActivationsController < ApplicationController
  skip_authorization_check unless: :current_player

  def activate
    if current_player
      authorize! :update, current_player

      if current_player.active?
        flash[:alert] = "You were already in the queue."
      else
        current_player.update! active: true
        flash[:notice] = "You've been queued to play."
      end

      redirect_back fallback_location: root_path
    else
      flash[:alert] = "You must be logged in to queue to play."
      redirect_to new_player_session_path
    end
  end
end
