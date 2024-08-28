class RunningSessionsController < ApplicationController
  def index
  end

  def show
    @running_session = RunningSession.find(params[:id])
    render :show, layout: false
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
    @date = @running_session.date
    @program = @running_session.program
    if @rest_interval_time.nil?
      @total_time = @run_interval_time
    else
      @total_time = (@run_interval_time * @run_interval_nbr) + (@rest_interval_time * (@run_interval_nbr - 1))
    end
  end

  def update
    running_session = RunningSession.find(params[:id])
    run = running_session.run
    kind = running_session_params[:kind]
    run_interval_km = running_session_params[:run_interval_km]
    run_interval_time = running_session_params[:run_interval_time]
    run_interval_nbr = running_session_params[:run_interval_nbr]
    rest_interval_time = running_session_params[:rest_interval_time]
    if running_session_params[:free_or_not] == "1"
      running_session.update!(
        kind:
      )
      if kind == 'Interval'
        run.update!(
          run_interval_km:,
          run_interval_time:,
          run_interval_nbr:,
          rest_interval_time:
        )
      else
        run.update!(
          run_interval_km:,
          run_interval_time:
        )
      end
      redirect_to program_path(running_session.program), notice: "Séance mise à jour"
    else
      running_session.destroy!
    end
  end

  private

  def running_session_params
    params.require(:running_session).permit(:free_or_not, :kind, :run_interval_km, :run_interval_time, :run_interval_nbr, :rest_interval_time)
  end
end
