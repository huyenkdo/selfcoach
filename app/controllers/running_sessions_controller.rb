class RunningSessionsController < ApplicationController
  def index
  end

  def edit
    @user = current_user
    # @program = Program.find(params[:id])
    @running_session = RunningSession.find(params[:id])
    run = @running_session.run
    @kind = run.kind
    @run_interval_km = run.run_interval_km
    @rest_interval_time = run.rest_interval_time
    @run_interval_nbr = run.run_interval_nbr
    @run_interval_pace = run.run_interval_pace
    @run_interval_time = run.run_interval_time
  end

  def update
    raise
    @user = current_user
    # @program = Program.find(params[:id])
    @running_sessions = RunningSession.find(params[:id])
  end

end
