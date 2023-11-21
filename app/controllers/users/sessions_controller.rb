

class Users::SessionsController < Devise::SessionsController
    before_action :authenticate_request, except: [:new, :create]
    respond_to :json
    private
    
    def respond_with(resource,option={})
      render json:{
        status:{
          code:200,
          message:'User is successfully signed in',
          data:current_user,
        }
      },status: :ok
    end

    def respond_to_on_destroy
      begin
        jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1], Rails.application.credentials.fetch(:secret_key_base)).first
        current_user = User.find(jwt_payload['sub'])
        if current_user
          render json: {
            status:200,
            message: "signed_out successfully"
          },status: :ok
        else
          render json: {
            status: 401,
            message:"User is not active sessions"
          },status: :Unauthorized
        end
      rescue JWT::ExpiredSignature
        render json: { error: 'Token has expired' }, status: :ok
      rescue JWT::DecodeError
        render json: { error: 'Invalid token' }, status: :unauthorized
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'User not found' }, status: :unauthorized
      end      
    end
end
