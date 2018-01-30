class UsersController < ApplicationController
  def index
    @users = User.all
  end
  
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    
    @valid_number = validate_phone(@user.phone_number)
    
    if @valid_number
      @user.save
      send_message(@user.note,@user.phone_number)
      redirect_to @user
    else
      puts "valid number???"
      puts @user.errors.count
      render :new
    end
  end
  
  private

  def validate_phone(phone_number)
    Phonelib.valid?(phone_number)
  end

  def send_message(message,phone_number)
    twilio_number = '+14432143863'
    account_sid = 'ACe8e0fbc0905829b77c467cec04338ada'
    auth_token = 'b58743ba80f37d17a101c972abc784af'

    @client = Twilio::REST::Client.new account_sid, auth_token
    message = @client.api.accounts(account_sid).messages.create(
      :from => twilio_number,
      :to => phone_number,
      :body => message
    )
  end

  def user_params
    params.require(:user).permit(
      :name, :phone_number, :note
    )
  end
end
