class PagesController < ApplicationController
  def home
    @run = Run.new

    unless @run
      flash[:alert] = "Aucun run trouvé."
      redirect_to some_other_path
    end
  end
end
