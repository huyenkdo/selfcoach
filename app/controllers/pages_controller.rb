class PagesController < ApplicationController
  def home
    @run_session = RunningSession.order(:date).first
    @run_date = @run_session.date if @run_session
    @run = @run_session.run if @run_session

    unless @run
      flash[:alert] = "Aucun run trouvé."
      redirect_to some_other_path
    end
  end

  def recap
    @user = current_user
  end
end
