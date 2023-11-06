require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
    before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
    end
    describe 'POST #create' do
        let!(:user) { create(:user, email: 'test@example.com', password: 'password123') }
        
        it 'signs in a user' do
            post :create,params: {user: {email:'test@example.com',password:'password123'}}
            expect(response).to have_http_status(:ok)
            expect(response.content_type).to eq('application/json; charset=utf-8')
            json_response = JSON.parse(response.body)
            expect(json_response['status']['code']).to eq(200)
            expect(json_response['status']['message']).to eq('User is successfully signed in')
            expect(json_response['status']['data']['email']).to eq('test@example.com')
        end
        it 'returns unauthorized for invalid credentials' do
            post :create, params: { user: { email: 'test@example.com', password: 'invalidpassword' } }
            expect(response).to have_http_status(:unauthorized)
            expect(response.content_type).to eq('text/html; charset=utf-8')
        end
    end
    describe 'DELETE #destroy' do
    let!(:user) { create(:user, email: 'test@example.com', password: 'password123') }

    it 'signs out a user successfully' do
      jwt_token = JWT.encode({ sub: user.id }, Rails.application.credentials.fetch(:secret_key_base), 'HS256')
      request.headers['Authorization'] = "Bearer #{jwt_token}"
      delete :destroy
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq(200)
      expect(json_response['message']).to eq('signed_out successfully')
    end

    it 'returns unauthorized if JWT token is expired' do
      jwt_token = JWT.encode({ sub: user.id ,exp: Time.now.to_i - 1 }, Rails.application.credentials.fetch(:secret_key_base), 'HS256')
      request.headers['Authorization'] = "Bearer #{jwt_token}"
      delete :destroy
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq('Token has expired')
    end

    it 'returns unauthorized if JWT token is invalid' do
      jwt_token = 'invalid_token'
      request.headers['Authorization'] = "Bearer #{jwt_token}"
      delete :destroy
      expect(response).to have_http_status(:unauthorized)
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq('Invalid token')
    end

    it 'returns unauthorized if user is not found' do
      jwt_token = JWT.encode({ sub: 99999 }, Rails.application.credentials.fetch(:secret_key_base), 'HS256')
      request.headers['Authorization'] = "Bearer #{jwt_token}"
      delete :destroy
      expect(response).to have_http_status(:unauthorized)
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq('User not found')
    end
  end

end
