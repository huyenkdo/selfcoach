class RunningSessionsController < ApplicationController
  def index
  end

  def edit
    @user = current_user
    # @program = Program.find(params[:id])
    @running_sessions = RunningSession.find(params[:id])
  end

  def update
    @user = current_user
    # @program = Program.find(params[:id])
    @running_sessions = RunningSession.find(params[:id])
  end

end
