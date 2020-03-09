class DogsController < ApplicationController
  def index
    @dogs = Dog.all
  end

  def show
    @dog = Dog.find(params[:id])
    if @dog.schedule.present?
      @schedule = @dog.schedule
    else
      @schedule = Schedule.new
    end
  end

  def new
    @owner = Owner.new
    @owner.dogs.build
  end

  def create
    # dog = Dog.new(set_dog_params)
    # if dog.save
    #   redirect_to dog_path(dog)
    # else
    #   render :new
    # end
  end

   def edit
    @dog = Dog.find(params[:id])
    @owner = @dog.owner
  end


  def destroy
    @dog = Dog.find(params[:id])
    @dog.delete
    redirect_to dogs_path
  end

  private

  def set_dog_params
    params.require(:dog).permit(:name, :breed, :pick_up_address, :special_requirements)
  end

end

# to be inserted in params: , owners_attributes:[:first_name, :last_name, :phone_number, :email]
