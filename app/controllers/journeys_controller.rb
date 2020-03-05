class JourneysController < ApplicationController
  def map
    current_time = Time.now
    year = current_time.year
    month = current_time.month
    day = current_time.day

    date = Date.new(year, month, day)
    # date.friday? => false

    # if @walk.date == date.today
    # need to pass through the particular instance of walk for the day we are currently on
    # that walk.slots then, get the dog from each slot and send the dogs lat and lng through the dataset in the map div
    @dogs = Dog.geocoded #returns dogs with coordinates

    @markers = @dogs.map do |dog|
      {
        lat: dog.latitude,
        lng: dog.longitude
      }
    end
  end
end
