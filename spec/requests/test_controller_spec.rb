require 'rails_helper'

RSpec.describe Api::V1::TestsController, type: :controller do
    let!(:user) { create(:user, email: 'test@example.com', password: 'password123',role:'admin') }
	before do
		jwt_token = JWT.encode({ sub: user.id,role:"admin"}, Rails.application.credentials.fetch(:secret_key_base), 'HS256',exp:30.minutes.to_i)
		request.headers['Authorization'] = "Bearer #{jwt_token}"
	end
    describe 'POST #create' do
        it 'creates a new test' do
        post :create, params: { test: { name: 'Test Name', price: 100 } }
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['status'])=='SUCCESS'
        expect(json_response['message'])=='successfully added Test in hospital'
        expect(json_response['data']['name']).to eq('Test Name')
        expect(json_response['data']['price']).to eq(100)
        end

        it 'fails to create a test with invalid parameters' do
        post :create, params: { test: { name: '', price: -10 } }
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['status'])=='ERROR'
        expect(json_response['message'])=='Test cannot be added'
        expect(json_response['data']).to be_a(Hash)
        expect(json_response['data']).to have_key('name')
        expect(json_response['data']).to have_key('price')
        end
    end

    describe 'GET #index' do
        it 'returns a list of all tests' do
        create(:test, name: 'Test 1', price: 50)
        create(:test, name: 'Test 2', price: 75)

        get :index

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['status'])=='SUCCESS'
        expect(json_response['message'])=='List of all Tests'
        expect(json_response['data'].count).to eq(2)
        expect(json_response['data'][0]['name']).to eq('Test 1')
        expect(json_response['data'][1]['price']).to eq(75)
        end
    end
end
    