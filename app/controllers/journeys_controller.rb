class JourneysController < ApplicationController
  def map
    @map = true
    @user_coordinates = [current_user.latitude, current_user.longitude]
    #  find walk from todays date
    @walk = Walk.where(date: Date.today).first
    @slots = @walk.slots
    coords = []
    @dog_coordinates = {}
    @slots.each_with_index do |slot, index|
      @dog_coordinates[index] = [slot.dog.latitude, slot.dog.longitude]
    end
    result = Geocoder.search("Großer Tiergarten, Berlin")
    @destination = result.first.coordinates
  end
end
