class WalksController < ApplicationController

  def schedule
    @walk = Walk.find_by date: params[:date]
    # this is test
    @slot = Slot.new(walk: @walk)


    today = Date.today
    days_from_this_week = today.at_beginning_of_week..today.at_end_of_week
    @days_from_this_week = days_from_this_week.reject{ |date| date.saturday? || date.sunday? }
  end





end


# <%= link_to (Date.today).strftime("%A"), walks_schedule_path(Date.today) %>

# <%= link_to (Date.today+1).strftime("%A"), walks_schedule_path(Date.today+1) %>
