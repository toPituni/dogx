class SlotsController < ApplicationController

  def new

  end

  #  create a slot
  def create
    @slot = Slot.new(set_slot)
    @slot[:status] = 1
    @slot.save
    redirect_to walks_schedule_path(@slot.walk[:date])
  end

  #  delete a slot
  def destroy
    @slot = Slot.find(params[:id])
    if  Slot.destroy(@slot.id)
       redirect_to walks_schedule_path(@slot.walk[:date])
    end
  end


  private

  def set_slot
    params.require(:slot).permit(:dog_id,:walk_id)
  end

end
