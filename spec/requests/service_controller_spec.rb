require 'rails_helper'

RSpec.describe Api::V1::ServicesController, type: :controller do
	let!(:user) { create(:user, email: 'test@example.com', password: 'password123',role:'admin') }
	before do
		jwt_token = JWT.encode({ sub: user.id,role:"admin"}, Rails.application.credentials.fetch(:secret_key_base), 'HS256',exp:30.minutes.to_i)
		request.headers['Authorization'] = "Bearer #{jwt_token}"
	end
	describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new service' do
        post :create, params: { service: { name: 'Service Name', price: 50 } }
        byebug
        expect(response).to have_http_status(:ok)
				expect(response.content_type).to eq('application/json; charset=utf-8')
				json_response = JSON.parse(response.body)
        expect(json_response['status'])=='SUCCESS'
        expect(json_response['message'])=='successfully added service in hospital'
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new service' do
        post :create, params: { service: { name: '', price: -10 } } 
        expect(response).to have_http_status(:unprocessable_entity)
				json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('ERROR')
        expect(json_response['message']).to eq('service cannot be added')
        expect(json_response['data']['name']).to include("can't be blank")
        expect(json_response['data']['price']).to include('must be greater than or equal to 0')
      end
    end
  end

  describe 'GET #index' do
    it 'returns a list of all services' do
      create(:service, name: 'Service 1', price: 50)
      create(:service, name: 'Service 2', price: 75)

      get :index
      
      expect(response).to have_http_status(:ok)
			json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('SUCCESS')
      expect(json_response['message']).to eq('List of all services')
      expect(json_response['data'].count).to eq(2)
      expect(json_response['data'][0]['name']).to eq('Service 1')
      expect(json_response['data'][1]['price']).to eq(75)
    end
  end

  describe 'GET #show' do
    let(:service) { create(:service, name: 'Service Name', price: 50) }

    context 'when service exists' do
      it 'returns the requested service' do
        get :show, params: { id: service.id }
        
        expect(response).to have_http_status(:ok)
				json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('SUCCESS')
        expect(json_response['message']).to eq('Loaded service')
        expect(json_response['data']['name']).to eq('Service Name')
        expect(json_response['data']['price']).to eq(50)
      end
    end

    context 'when service does not exist' do
      it 'returns a not found error' do
        get :show, params: { id: 99999 }

        expect(response).to have_http_status(:not_found)
				json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('ERROR')
        expect(json_response['message']).to eq('service not found')
        expect(json_response['data']).to be_empty
      end
    end
  end

  describe 'PUT #update' do
    let(:service) { create(:service, name: 'Service Name', price: 50) }

    context 'with valid parameters' do
      it 'updates the service' do
        put :update, params: { id: service.id, service: { name: 'Updated Service', price: 75 } }

        expect(response).to have_http_status(:ok)
				json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('SUCCESS')
        expect(json_response['message']).to eq('service updated')
        expect(json_response['data']['name']).to eq('Updated Service')
        expect(json_response['data']['price']).to eq(75)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the service' do
        put :update, params: { id: service.id, service: { name: '', price: -10 } }

        expect(response).to have_http_status(:unprocessable_entity)
				json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('ERROR')
        expect(json_response['message']).to eq('Update failed')
        expect(json_response['data']['name']).to include("can't be blank")
        expect(json_response['data']['price']).to include('must be greater than or equal to 0')
      end
    end

    context 'when service does not exist' do
      it 'returns a not found error' do
        put :update, params: { id: 99999, service: { name: 'Updated Service', price: 75 } }

        expect(response).to have_http_status(:not_found)
				json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('ERROR')
        expect(json_response['message']).to eq('service not found')
        expect(json_response['data']).to be_empty
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:service) { create(:service, name: 'Service Name', price: 50) }

    context 'when service exists' do
      it 'deletes the service' do
        delete :destroy, params: { id: service.id }

        expect(response).to have_http_status(:ok)
				json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('SUCCESS')
        expect(json_response['message']).to eq('service removed')
        expect(json_response['data']).to be_empty
      end
    end

    context 'when service does not exist' do
      it 'returns a not found error' do
        delete :destroy, params: { id: 99999 }

        expect(response).to have_http_status(:not_found)
				json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('ERROR')
        expect(json_response['message']).to eq('service not found')
        expect(json_response['data']).to be_empty
      end
    end
  end
end
