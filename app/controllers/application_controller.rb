    class ApplicationController < ActionController::API

        before_action :authenticate_request
        private
        
        def authenticate_request
            begin
                if request.headers['Authorization']
                    token = request.headers['Authorization']&.split(' ')[1]
                    decoded_token = JWT.decode(token, Rails.application.credentials.fetch(:secret_key_base), true, algorithm: 'HS256')
                    if decoded_token
                        @current_user=User.find(decoded_token[0]['sub'])
                    else
                        render json: { error: 'Unauthorized' }, status: :unauthorized
                    end
                else
                    render json: { error: 'Unauthorized' }, status: :unauthorized
                end

            rescue JWT::ExpiredSignature
            render json: { error: 'Token has expired' }, status: :unauthorized
            rescue JWT::DecodeError
            render json: { error: 'Invalid token' }, status: :unauthorized
            end
        end
        
        def token_expired?(decoded_token)
        Time.at(decoded_token['exp']) < Time.now
        end
        
    end
