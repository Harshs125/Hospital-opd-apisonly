class ApplicationController < ActionController::API
    before_action :authenticate_request

    private
    def authenticate_request
        token=request.headers['Authorization']&.split(' ')&.last
        decoded_token = JWT.decode(token,'')
    end
end
