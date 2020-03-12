class SlotsController < ApplicationController

  def new

  end

  #  create a slot
  def create
    @walk = Walk.find(params[:slot][:walk_id])
    @slot = Slot.new(slot_params)
    @slot[:status] = 1
    if @slot.save
      respond_to do |format|
        format.html {  render template: 'slots/form' }# redirect_to walks_schedule_path(params[:date]) }
        format.js  # <-- will render `app/views/slots/create.js.erb`
      end
    else
      respond_to do |format|
        format.html { render walks_schedule_path(params[:date]) }
        format.js  # <-- idem
      end
    end

  end

  #  delete a slot
  def destroy
    @slot = Slot.find(params[:id])
    @walk = @slot.walk
    Slot.destroy(@slot.id)
  end


  private

  def slot_params
    params.require(:slot).permit(:dog_id,:walk_id)
  end

end
