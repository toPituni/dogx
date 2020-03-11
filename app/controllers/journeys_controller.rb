class JourneysController < ApplicationController
  def map
    @map = true
    @user_coordinates = [current_user.latitude, current_user.longitude]
    #  find walk from todays date
    @walk = Walk.where(date: Date.today).first
    @slots = @walk.slots
    coords = []
    @dog_coordinates = {}
    @dog_info = []
    @slots.each_with_index do |slot, index|
      @dog_coordinates[index] = [slot.dog.latitude, slot.dog.longitude]
      @dog_info << {
        name: slot.dog.name,
        address: slot.dog.address,
        coords: [slot.dog.latitude, slot.dog.longitude],
        owner: slot.dog.owner.first_name,
      }
    end
    result = Geocoder.search("Großer Tiergarten, Berlin")
    @destination = result.first.coordinates
  end
end
