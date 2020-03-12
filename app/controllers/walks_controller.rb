class WalksController < ApplicationController

  def schedule
    today = params[:date].to_date
    # if i check on saturday/sunday it will show next week's schedule
    if today.saturday? || today.sunday?
      today = today.next_week
    end
    @walk = Walk.find_by date: today
    # @walk = Walk.find_by date: params[:date]
    @walk = Walk.new if @walk.nil?
    @slots = @walk.slots.order(:id)
    # @slots = @walk.slots.order(:created_at)

    # Below @slot is for creating new slot
    @slot = Slot.new(walk: @walk)

    days_from_this_week = today.at_beginning_of_week..today.at_end_of_week
    @days_from_this_week = days_from_this_week.reject{ |date| date.saturday? || date.sunday? }
  end

end


