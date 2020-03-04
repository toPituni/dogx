class DogsController < ApplicationController
  before_action :set_dog, only: [ :show, :edit, :update, :destroy ]
  def index
    @dogs = Dog.all
  end

  def show
  end

  def new
    @dog = Dog.new
  end

  def create
    dog = Dog.new(set_dog_params)
    if dog.save
      redirect_to dog_path(dog)
    else
      render :new
    end
  end

  def edit
  end

  def update
    @dog.update(set_dog_params)
    redirect_to dog_path(@dog)
  end

  def destroy
    @dog.delete
    redirect_to dogs_path
  end

  private

  def set_dog_params
    params.require(:dog).permit(:name, :breed, :pick_up_address, :special_requirements)
  end

  def set_dog
    @dog = Dog.find(params[:id])
  end
end

# to be inserted in params: , owners_attributes:[:first_name, :last_name, :phone_number, :email]
