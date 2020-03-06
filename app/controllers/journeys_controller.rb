class JourneysController < ApplicationController
  def map
    @map = true
    @user_coordinates = [current_user.latitude, current_user.longitude]
    @walk = Walk.where(date: Date.today)
    @slots = Slot.where(walk_id: @walk.ids)
    coords = []
    @dog_coordinates = {}
    @slots.each_with_index do |slot, index|
      @dog_coordinates[index] = [slot.dog.latitude, slot.dog.longitude]
    end

    result = Geocoder.search("Krumme Lanke, Berlin")
    @destination = result.first.coordinates
  end
end
