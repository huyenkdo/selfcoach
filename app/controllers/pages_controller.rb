class PagesController < ApplicationController
  def home
    start_date_week = Date.current.beginning_of_week(:monday)
    end_date_week = Date.current.end_of_week(:sunday)

    start_date = Date.current
    end_date = start_date + 6

    @user = current_user
    @program = @user.programs.last

    if @program.nil?
      flash[:alert] = "Aucun programme trouvé."
      redirect_to some_other_path
      return
    end

    @run_session = @program.running_sessions.order(:date).first
    @run_date = @run_session.date if @run_session
    @run = @run_session.run if @run_session

    unless @run
      flash[:alert] = "Aucun run trouvé."
      redirect_to some_other_path
      return
    end

    @total_time = @run.total_time
    @warmup_time = @run.warmup_time
    @session_details = @run.session_details
    @run_star = @run.difficulty

    @formatted_total_time = @run.formatted_time(@total_time)
    @formatted_warmup_time = @run.formatted_time(@warmup_time)

    @next_week_sessions = @program.running_sessions.where(date: start_date..end_date).order(:date)

    total_sessions = @program.running_sessions.count
    completed_sessions = @program.running_sessions.where(status: 'completed').count
    @completion_percentage = (completed_sessions.to_f / total_sessions.to_f * 100).round(0)

    race_date = @program.race_date
    @days_before_race = (race_date - Date.current).to_i

    @km_this_week = 0
    @total_time_this_week = 0

    @program.running_sessions.joins(:run).where(date: start_date_week..end_date_week, status: 'completed').each do |session|
      run = session.run
      @km_this_week += run.real_total_km_ran
      @total_time_this_week += run.real_total_time_ran
    end
    @km_this_week = @km_this_week.round(2)
    @formatted_total_time_this_week = @run.formatted_time(@total_time_this_week)

    @latest_completed_session = @program.running_sessions.where(status: 'completed').max_by { :date }
    @latest_run = @latest_completed_session.run unless @latest_completed_session.nil?
    @latest_run_km = @latest_run.real_total_km_ran unless @latest_run.nil?
    @latest_run_km = 0 if @latest_run.nil?

    # @real_total_km_ran = @run.real_total_km_ran
    @real_total_time_ran = @latest_run.real_total_time_ran unless @latest_run.nil?
    @real_total_time_ran = 0 if @latest_run.nil?
    @real_avg_pace_ran = @latest_run.real_avg_pace_ran unless @latest_run.nil?
    @real_avg_pace_ran = 0 if @latest_run.nil?
  end

  def recap
    @user = current_user
  end
end
