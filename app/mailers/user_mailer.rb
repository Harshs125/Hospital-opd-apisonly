class UserMailer < ApplicationMailer
    def confirmation_email
        @user= params[:user]
        @email=@user.email
        @username=@user.username
        @password=@user.password
        mail(to: @email,subject: 'Welcome to Hospital management web')
    end
end
