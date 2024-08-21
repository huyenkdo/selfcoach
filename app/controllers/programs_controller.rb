class ProgramsController < ApplicationController
  before_action :set_program, only: :show

  def show
    @running_sessions = RunningSession.all
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
  end

  def new
    @program = Program.new
  end

  def create
  end

  def edit
  end

  def update
  end

  def recap
  end

  private

  def set_program
    @program = Program.find(params[:id])
  end

  # def program_params
    # params.require(:program).permit(free_days: [])
  # end
end
