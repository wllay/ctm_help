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

    if @user.valid?
      @user.save
      if send_message(@user.note,@user.phone_number)
        redirect_to @user
      else
        render :new
      end
    else
      puts "valid number???"
      puts @user.errors
      render :new
    end
  end
  
  def update
    @user = User.find(params[:id])
   
    if @user.valid?
      @user.update(user_params)
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def validate_phone(phone_number)
    phone_object = TelephoneNumber.parse(phone_number, :us)
    phone_object.valid?
    #Phonelib.valid?(phone_number)
  end
  
  private

  def send_message(message,phone_number)
    twilio_number = '+14432143863'
    account_sid = 'ACe8e0fbc0905829b77c467cec04338ada'
    auth_token = 'b58743ba80f37d17a101c972abc784af'

    begin
      @client = Twilio::REST::Client.new account_sid, auth_token
      message = @client.api.accounts(account_sid).messages.create(
        :from => twilio_number,
        :to => phone_number,
        :body => message
      )
    rescue Twilio::REST::TwilioError => e
      @user.errors.add(:phone_number, "Text cannot be sent")
      return false
    end
  end

  def user_params
    params.require(:user).permit(
      :name, :phone_number, :note
    )
  end
end
