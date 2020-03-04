class JourneysController < ApplicationController
  def map
    @dogs = Dog.geocoded #returns dogs with coordinates

    @markers = @dogs.map do |dog|
      {
        lat: dog.latitude,
        lng: dog.longitude
      }
    end
  end
end
