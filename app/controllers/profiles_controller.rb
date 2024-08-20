class ProfilesController < ApplicationController
  def show
    @user = current_user
  end

  def update
    if current_user.update!(user_params)
      redirect_to new_program_path
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :age, :weight, :vma)
  end
end
