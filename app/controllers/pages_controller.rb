class PagesController < ApplicationController
  def home
    start_date = Date.current + 1.day
    end_date = start_date + 6.days

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
    completed_sessions = @program.running_sessions.where("date <= ?", Date.current).count
    @completion_percentage = (completed_sessions.to_f / total_sessions.to_f * 100).round(0)

    race_date = @program.race_date
    @days_before_race = (race_date - Date.current).to_i

    @km_this_week = 0
    @total_time_this_week = 0
    @program.running_sessions.joins(:run).where(date: start_date..end_date).each do |session|
      run = session.run
      @km_this_week += run.run_interval_km * run.run_interval_nbr
      @total_time_this_week += run.total_time
    end
    @km_this_week = @km_this_week.round(2)
    @formatted_total_time_this_week = @run.formatted_time(@total_time_this_week)

    @km_this_week = 0
    @total_time_this_week = 0
    @program.running_sessions.joins(:run).where(date: start_date..end_date, status: 'completed').each do |session|
      run = session.run
      @km_this_week += run.run_interval_km * run.run_interval_nbr
      @total_time_this_week += run.total_time
    end
    @km_this_week = @km_this_week.round(2)
    @formatted_total_time_this_week = @run.formatted_time(@total_time_this_week)

    # @real_total_km_ran = @run.real_total_km_ran
    # @real_total_time_ran = @run.real_total_time_ran
    # @real_avg_pace_ran = @run.real_avg_pace_ran
  end

  def recap
    @user = current_user
  end
end
