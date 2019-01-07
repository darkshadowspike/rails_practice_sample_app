class UsersController < ApplicationController
  def new
  	#debugger
  	@user =User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
       flash[:success] ="User succesfully created!"
       redirect_to user_url(@user)
    else
      #flash[:danger] ="User couldn't be created"
      render "new"
    end
  end

  def show
  	@user = User.find(params[:id])
  	#debugger
  end

  def edit
  end

  def update
  end

  def destroy
  end

   private

   def user_params
        params.require(:user).permit(:name,:email,:password,:password_confirmation)
   end
end
