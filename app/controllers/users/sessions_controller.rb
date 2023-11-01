# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
    respond_to :json
    private
    
    def respond_with(resource,option={})
      token = generate_jwt_token(resource)
      render json:{
        status:{
          code:200,
          message:'User is successfully signed in',
          data:current_user
        }
      },status: :ok
    end

    def respond_to_on_destroy
      
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1],Rails.application.credentials.fetch(:secret_key_base)).first
      puts "----->>>>>>>>>>.#{jwt_payload}"
      current_user=User.find_by(id: jwt_payload['user_id'])
      if current_user
        render json: {
          status: 200,
          message: "Signout successfully"
        }, status: :ok        
      else
        render json:{
          status:401,
          message:"User has no active session"
        }, status: :unauthorise
      end
    end

    def generate_jwt_token(user)
      payload={user_id:user.id,role:user.role}
      JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256')
    end
    # before_action :configure_sign_in_params, only: [:create]

    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    # def create
    #   super
    # end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end
end
