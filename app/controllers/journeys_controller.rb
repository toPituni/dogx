class JourneysController < ApplicationController
  def map
    @map = true
    @user_coordinates = [current_user.latitude, current_user.longitude]
    #  find walk from todays date
    @walk = Walk.where(date: Date.today)
    @slots = Slot.where(walk_id: @walk.ids)
    # iterate over the slots, and for each slot.dog
    # push the dogs lat, lng as an object, into a parent array
    # this parent array we will access in the view, with the dataset
    @dog_coordinates = []
    @slots.each do |slot|
    @dog_coordinates << [slot.dog.latitude, slot.dog.longitude]
    end
    puts @dogCoordinates
  end
end
