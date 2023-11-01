class UserMailer < ApplicationMailer
    # default from: 'harshsoni12501@gmail.com'
    
    def confirmation_email
        @user= params[:user]
        @email=@user.email
        @username=@user.username
        @password=@user.encrypted_password
        # puts "---->>>>>>>>>>>>>>>>>>>>>>.#{@email}#{@user.encrypted_password}"
        mail(to: @email,subject: 'Welcome to Hospital management web')
    end
end
