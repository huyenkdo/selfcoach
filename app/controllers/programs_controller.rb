require 'ice_cube'
require 'active_support/time'

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
    @user = current_user
    program = Program.new(program_params)

    free_days = program_params[:free_days].reject(&:blank?).map(&:to_i)
    program.free_days = free_days

    program.user = @user

    objective_time = (program_params[:objective_time_hours].to_i * 60) + program_params[:objective_time_mins].to_i
    program.objective_time = objective_time

    weekend_days = [0, 6]
    free_weekend_days = free_days & weekend_days

    long_run_day = nil
    easy_run_days = []

    if free_weekend_days.size == 1
      # Assign the first available weekend day as the long run day
      long_run_day = free_weekend_days.first
      # If the day before long ruj is available, make it an easy run
      easy_run_days << free_days[-2] if long_run_day == 6 && free_days.include?(long_run_day - 1)
    elsif free_weekend_days.size == 2
      long_run_day = free_weekend_days.first
      easy_run_days << free_days[-2] if long_run_day == 6 && free_days.include?(long_run_day - 1)
    else
      # If no weekend days are free, assign the first available free day as the long run day
      long_run_day = free_days.first
    end

    remaining_free_days = free_days - [long_run_day] - easy_run_days
    interval_or_tempo_run_day = remaining_free_days.first
    remaining_free_days -= [interval_or_tempo_run_day]
    remaining_free_days.each { |day| easy_run_days << day } unless remaining_free_days.blank?

    race_date = Date.parse(program_params[:race_date])
    # add reccurences
    schedule = IceCube::Schedule.new
    # add long run occurrences
    schedule.add_recurrence_rule IceCube::Rule.weekly.day(long_run_day)
    long_run_recurrences = schedule.occurrences_between(Date.current.next_occurring(:sunday), race_date, spans: true)
    # add easy run occurrences
    schedule = IceCube::Schedule.new
    schedule.add_recurrence_rule IceCube::Rule.weekly.day(easy_run_days)
    easy_run_recurrences = schedule.occurrences_between(Date.current.next_occurring(:sunday), race_date, spans: true)
    # add interval or tempo run occurrences
    schedule = IceCube::Schedule.new
    schedule.add_recurrence_rule IceCube::Rule.weekly.day(interval_or_tempo_run_day)
    interval_or_tempo_run_recurrences = schedule.occurrences_between(Date.current.next_occurring(:sunday), race_date, spans: true)
    # choose from these recurrences the ones that will be interval runs or tempo runs
    interval_run_recurrences = interval_or_tempo_run_recurrences.map do |recurrence|
      recurrence if [0, 1].sample.zero?
    end
    interval_run_recurrences.compact!
    tempo_run_recurrences = interval_or_tempo_run_recurrences - interval_run_recurrences

    if program.save
      @user.vma = (52 - (0.35 * @user.age)) / 3.5 if @user.vma.blank?

      easy_pace = @user.vma * 0.65
      tempo_pace = @user.vma * 0.85
      interval_pace = @user.vma * 0.95

      base_long_run_distance = program_params[:objective_km].to_f * 0.2
      target_long_run_distance = program_params[:objective_km].to_f

      weeks_until_race = ((race_date - Date.today).to_i / 7).ceil

      total_distance_to_increase = target_long_run_distance - base_long_run_distance

      increment_distance = total_distance_to_increase / weeks_until_race

      base_tempo_distance = 0.15 * program_params[:objective_km].to_f
      tempo_increment_distance = 0.1 * program_params[:objective_km].to_f

      easy_run_recurrences.each do |recurrence|
        easy_run = Run.create!(
          kind: 'Easy',
          run_interval_km: distance = rand(2..5),
          run_interval_time: ((distance / easy_pace) * 60).round(2),
          run_interval_pace: easy_pace,
          run_interval_nbr: 1,
          difficulty: 1,
          hr_zone: 'Zone 2'
        )
        RunningSession.create!(
          program_id: program.id,
          run_id: easy_run.id,
          date: recurrence
        )
      end

      long_run_recurrences.each_with_index do |recurrence, i|
        long_run_distance = base_long_run_distance + (i * increment_distance)
        long_run = Run.create!(
          kind: 'Long',
          run_interval_km: long_run_distance,
          run_interval_time: ((long_run_distance / easy_pace) * 60).round(2),
          run_interval_pace: easy_pace,
          run_interval_nbr: 1,
          difficulty:
            if long_run_distance > program_params[:objective_km].to_f * 0.7
              3
            else
              2
            end,
          hr_zone: 'Zone 2'
        )
        RunningSession.create!(
          program_id: program.id,
          run_id: long_run.id,
          date: recurrence
        )
      end

      interval_run_recurrences.each do |recurrence|
        interval_run = Run.create!(
          kind: 'Interval',
          run_interval_time: run_time = rand(1..3),
          run_interval_km: ((run_time / 60) * interval_pace).round(2),
          run_interval_pace: interval_pace,
          rest_interval_time: rest_time = 1,
          rest_interval_km: ((rest_time / 60) * interval_pace).round(2),
          rest_interval_pace: easy_pace,
          run_interval_nbr: rand(7..10),
          difficulty: 5,
          hr_zone: 'Zone 4'
        )
        RunningSession.create!(
          program_id: program.id,
          run_id: interval_run.id,
          date: recurrence
        )
      end

      tempo_run_recurrences.each_with_index do |recurrence, i|
        tempo_run_distance = base_tempo_distance + (tempo_increment_distance * i)
        tempo_run = Run.create!(
          kind: 'Tempo',
          run_interval_km: tempo_run_distance,
          run_interval_time: ((tempo_run_distance / tempo_pace) * 60).round(2),
          run_interval_pace: tempo_pace,
          run_interval_nbr: 1,
          difficulty: 4,
          hr_zone: 'Zone 3'
        )
        RunningSession.create!(
          program_id: program.id,
          run_id: tempo_run.id,
          date: recurrence
        )
      end
      redirect_to recap_program_path(program)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @program = Program.find(params[:id])

    if user_params_present?
       @user.update(user_params)
        redirect_to recap_program_path, notice: 'Profil mis à jour avec succès.'
    elsif program_params_present?
       @program.update(program_params)
        redirect_to recap_program_path, notice: 'Objectif mis à jour avec succès.'
      else
        render :edit
      end

  end

  def recap
    @user = current_user
    @program = Program.find(params[:id])
    # @running_sessions = RunningSession.find(params[:id])
    @sessions = @program.running_sessions.where(date: Date.today..Date.today+7.days)
    
  end

  private

  def set_program
    @program = Program.find(params[:id])
  end

  def program_params
    params.require(:program).permit(:objective_km, :race_date, :objective_time, :objective_time_hours, :objective_time_mins, free_days: [])
  end

  def user_params
    params.require(:user).permit(:first_name, :age, :weight, :vma)
  end

  def user_params_present?
    params[:user].present? && user_params.values.any?(&:present?)
  end

  def program_params_present?
    params[:program].present? && program_params.values.any?(&:present?)
  end
end
