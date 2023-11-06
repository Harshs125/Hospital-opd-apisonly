require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
    before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
    end
    describe 'POST #create' do
        let!(:user) { create(:user, email: 'test@example.com', password: 'password123') }
        
        it 'signs in a user' do
            byebug
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
end
