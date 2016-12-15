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
      flash[:alert] = "You must be logged in to join the queue."
      redirect_to new_player_session_path
    end
  end

  def deactivate
    if current_player
      authorize! :update, current_player

      if current_player.active?
        current_player.update! active: false
        flash[:notice] = "You've been removed from the queue."
      else
        flash[:alert] = "You weren't queued to play."
      end

      redirect_back fallback_location: root_path
    else
      flash[:alert] = "You must be logged in to leave the queue."
      redirect_to new_player_session_path
    end
  end
end
