class WalksController < ApplicationController

  def schedule
    @walk = Walk.find_by date: params[:date]

    @slot = Slot.new(walk: @walk)

    today = params[:date].to_date

    # if i check on saturday/sunday it shows last week's. so I chaged to show next week schedule
    if today.saturday? || today.sunday?
      today = today.next_week
    end

    days_from_this_week = today.at_beginning_of_week..today.at_end_of_week
    @days_from_this_week = days_from_this_week.reject{ |date| date.saturday? || date.sunday? }
  end

end


# <%= link_to (Date.today).strftime("%A"), walks_schedule_path(Date.today) %>

# <%= link_to (Date.today+1).strftime("%A"), walks_schedule_path(Date.today+1) %>
# without
