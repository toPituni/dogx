class OwnersController < ApplicationController
  def create
    @owner = Owner.new(set_owner_params)
    if @owner.save
      redirect_to dogs_path
    else
      render 'new'
    end
  end


  def update
    @owner = Owner.find(params[:id])
    @owner.update(set_owner_params)
    redirect_to dogs_path
  end

  private

  def set_owner_params
    params.require(:owner).permit(:first_name, :last_name, :telephone_number, :email, dogs_attributes:[:id, :name, :pick_up_address, :breed, :special_requirements, :image])
  end

end

