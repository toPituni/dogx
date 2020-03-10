require 'date'

class WalkService

  def initialize(schedule_id)
    @schedule = Schedule.find(schedule_id)
    @user = User.find(@schedule.dog.user.id)
  end

  def create
    # First saving date to Walk
    # creating 2 weeks range for 2 weeks walk
   date_range =[]
   # next_day = Date.today
   next_day = Date.today.last_week

   until next_day.monday?
     next_day = (next_day - 1)
   end

   21.times do
     if next_day.friday?
       date_range << next_day
       next_day = (next_day + 3)
     elsif next_day.saturday?
       next_day = (next_day + 2)
       date_range << next_day
     elsif next_day.sunday?
       next_day = (next_day + 1)
       date_range << next_day
     else
       date_range << next_day
       next_day = (next_day + 1)
     end
   end

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

  def update
    # when the scedule weekday is true
    update_slots(1) if @schedule.monday
    update_slots(2) if @schedule.tuesday
    update_slots(3) if @schedule.wednesday
    update_slots(4) if @schedule.thursday
    update_slots(5) if @schedule.friday

    # when the scedule weekday is false
    destroy(1) unless @schedule.monday
    destroy(2) unless @schedule.tuesday
    destroy(3) unless @schedule.wednesday
    destroy(4) unless @schedule.thursday
    destroy(5) unless @schedule.friday

  end

  private

  def destroy(date)
    Slot.where(dog_id: @schedule.dog.id).joins(:walk).where("extract(dow from date) = ?", date).destroy_all
  end

  def update_slots(date)
    walks = Walk.where("extract(dow from date) = ?", date)
    walks.each do |walk|
      Slot.create(walk_id: walk.id, dog_id: @schedule.dog.id , status: 1) unless Slot.where(walk: walk, dog: @schedule.dog.id).present?
    end

  end


end


