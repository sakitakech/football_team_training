class CalendarController < ApplicationController
  def index
    @positions = Position.all
  end
end
