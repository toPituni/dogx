class JourneysController < ApplicationController
  def map
    #  find walk from todays date
    @walk = Walk.where(date: Date.yesterday) #NEEDS TO BE CHANGED!! SHOULD BE TODAY AND NOT YESTERDAY
    @slots = Slot.where(walk_id: @walk.ids)
    # iterate over the slots, and for each slot.dog
    # push the dogs lat, lng as an object, into a parent array
    # this parent array we will access in the view, with the dataset
    @dogCoordinates = []
    @slots.each do |slot|
    @dogCoordinates << { lat: slot.dog.latitude, lng: slot.dog.longitude }
    end
    puts @dogCoordinates
  end
end
