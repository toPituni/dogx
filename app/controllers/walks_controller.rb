class WalksController < ApplicationController

  def schedule
    @walk = Walk.find_by date: params[:date]
  end
end
