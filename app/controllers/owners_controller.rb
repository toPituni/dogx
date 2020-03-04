class OwnersController < ApplicationController
  def create
    @owner = Owner.new(set_owner_params)
    if @owner.save
      redirect_to dogs_path
    else
      render 'new'
    end
  end

  def set_owner_params
    params.require(:owner).permit(:first_name, :last_name, :telephone_number, :email, dogs_attributes:[:id, :name, :image, :pick_up_address, :breed, :special_requirements])
  end
end

