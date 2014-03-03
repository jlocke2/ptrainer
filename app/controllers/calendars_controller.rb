class CalendarsController < ApplicationController
	  before_filter :authenticate_user!


  def show
  	      @appointment = Appointment.new


  end

end