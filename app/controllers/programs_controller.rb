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

    free_days = program_params[:free_days].map(&:to_i).uniq
    program.free_days = free_days

    program.user = @user

    objective_time = (program_params[:objective_time_hours].to_i * 60) + program_params[:objective_time_mins].to_i
    program.objective_time = objective_time

    # add reccurences
    schedule.add_recurrence_rule IceCube::Rule.weekly.day(1, 2)

    raise
    if program.save

    else
      render :new, status: :unprocessable_entity
    end


    @user.vma = (52 - (0.35 * @user.age)) / 3.5 if @user.vma.blank?

    easy_pace = @user.vma * 0.65
    tempo_pace = @user.vma * 0.85
    interval_pace = @user.vma * 0.95

    race_date = Date.new(program_params["race_date(1i)"], program_params["race_date(2i)"], program_params["race_date(3i)"])

    base_long_run_distance = program_params[:objective_km] * 0.2
    target_long_run_distance = program_params[:objective_km]

    weeks_until_race = ((race_date - Date.today).to_i / 7).ceil

    total_distance_to_increase = target_long_run_distance - base_long_run_distance

    increment_distance = total_distance_to_increase / weeks_until_race

    weekend_days = [0, 6]
    free_weekend_days = free_days & weekend_days

    long_run_day = nil
    if free_weekend_days.any?
      # Assign the first available weekend day as the long run day
      long_run_day = free_weekend_days.first
    else
      # If no weekend days are free, assign the first available free day as the long run day
      long_run_day = free_days.first
    end

    remaining_free_days = free_days - [long_run_day]

    easy_run_day = remaining_free_days.first
    interval_run_day = remaining_free_days.second

    easy_run = Run.create!(
      kind: 'Easy',
      run_interval_km: (2..5).sample,
      run_interval_pace: easy_pace,
      difficulty: 1,
      hr_zone: 'Zone 2'
    )

    weeks_until_race.times do |week|
      long_run_distance = base_long_run_distance + (week * increment_distance)
      long_run = Run.create!(
        kind: 'Long',
        run_interval_km: long_run_distance,
        run_interval_pace: easy_pace,
        difficulty: 2,
        hr_zone: 'Zone 2'
      )
      RunningSession.create!(
        program_id: program.id,
        run_id: long_run.id,
        date: week_start_date + day_offset
      )
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
    @sessions = @program.running_sessions.where(date: Date.new(2024,8,19)..Date.new(2024,8,19)+7.days)
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
