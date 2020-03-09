class SchedulesController < ApplicationController
  # def new
  #   @schedule = Schedule.new
  # end
  def update
    @schedule = Schedule.find(params[:id])
    @schedule.update(set_schedule_params)
    redirect_to dog_path(@schedule.dog)
  end

  private

  def set_schedule_params
    params.require(:schedule).permit(:monday,:tuesday, :wednesday, :thursday, :friday)
  end


end
