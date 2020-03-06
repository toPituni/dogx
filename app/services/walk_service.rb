require 'date'

class WalkService

  def initialize(schedule_id)
    @schedule = Schedule.find(schedule_id)
    @user = User.find(@schedule.dog.user.id)
  end

  def create
    today = Date.today
    two_weeks_from_now = Date.today + 14

    # First saving date to Walk
    # creating 2 weeks range for 2 weeks walk
    date_range = (today..two_weeks_from_now).to_a
    date_range = date_range.reject { |date| date.saturday? || date.sunday? }

    date_range.each do |date|
      # finding weekday from date
      weekday = date.strftime("%A").downcase.to_sym
      walk_find = Walk.where(user_id: @user.id, date: date).first
      # creating walk for a day
      if walk_find.present?
        @walk = walk_find
      else
        @walk = Walk.create!(date: date, user_id: @user.id)
      end


      # selecting Dog's details according to schedule
      dogs = Dog.where(user_id: @user.id).joins(:schedule).where("%s IS true",weekday)


      dogs.each do |dog|
        # creating slots for the day
        Slot.create!(walk: @walk, dog: dog, status: 1) unless Slot.where(walk: @walk, dog: dog, status: 1).present?
      end

      # create slots for every dog that has a availability in the scedule
    end

  end

end


