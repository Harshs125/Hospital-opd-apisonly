require 'rails_helper'

RSpec.describe Api::V1::PatientsController, type: :controller do
    let!(:user) { create(:user, email: 'test@example.com', password: 'password123',role:'doctor') }
	before do
		jwt_token = JWT.encode({ sub: user.id,role:"doctor"}, Rails.application.credentials.fetch(:secret_key_base), 'HS256',exp:30.minutes.to_i)
		request.headers['Authorization'] = "Bearer #{jwt_token}"
	end
    describe 'GET #index' do
        it 'returns a list of all patients' do
        create(:patient, name: 'Patient 1', email: 'patient1@example.com', mobile: '1234567890')
        create(:patient, name: 'Patient 2', email: 'patient2@example.com', mobile: '9876543210')

        get :index

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['status'])=='SUCCESS'
        expect(json_response['message'])=='Loaded all patients'
        expect(json_response['data'].count)==2
        expect(json_response['data'][0]['name'])=='Patient 1'
        expect(json_response['data'][1]['email'])=='patient2@example.com'
        end
    end

    describe 'GET #show' do
        it 'returns a specific patient' do
        patient = create(:patient, name: 'Test Patient', email: 'test@example.com', mobile: '1234567890')

        get :show, params: { id: patient.id }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['status'])=='SUCCESS'
        expect(json_response['message'])=='Loaded patient'
        expect(json_response['data']['name'])=='Test Patient'
        expect(json_response['data']['mobile'])=='1234567890'
        end

        it 'returns an error if patient not found' do
        get :show, params: { id: 999 }

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['status'])=='ERROR'
        expect(json_response['message'])=='Patient Not Found'
        end
    end

    describe 'POST #create' do
        it 'creates a new patient' do
        post :create, params: { patient: { name: 'New Patient', email: 'new@example.com', mobile: '9876543210' } }
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['status'])=='SUCCESS'
        expect(json_response['message'])=='Patient created successfully'
        expect(json_response['data']['name'])=='New Patient'
        expect(json_response['data']['email'])=='new@example.com'
        end

        it 'fails to create a patient with invalid parameters' do
        post :create, params: { patient: { name: '', email: '', mobile: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['status'])=='ERROR'
        expect(json_response['message'])=='Patient creation failed'
        expect(json_response['data']).to be_a(Hash)
        expect(json_response['data']).to have_key('name')
        expect(json_response['data']).to have_key('email')
        end
    end

    describe 'PATCH #update' do
        it 'updates an existing patient' do
        patient = create(:patient, name: 'Old Name', email: 'old@example.com', mobile: '1234567890')

        patch :update, params: { id: patient.id, patient: { name: 'New Name' } }
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['status'])=='SUCCESS'
        expect(json_response['message'])=='Patient updated'
        expect(json_response['data']['name'])=='New Name'
        end

        it 'fails to update a patient with invalid parameters' do
        patient = create(:patient, name: 'Old Name', email: 'old@example.com', mobile: '1234567890')

        patch :update, params: { id: patient.id, patient: { name: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['status'])=='ERROR'
        expect(json_response['message'])=='Update failed'
        expect(json_response['data']).to be_a(Hash)
        expect(json_response['data']).to have_key('name')
        end

        it 'returns an error if patient not found' do
        patch :update, params: { id: 999, patient: { name: 'New Name' } }
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['status'])=='ERROR'
        expect(json_response['message'])=='Patient not found'
        end
    end

    describe 'DELETE #destroy' do
        it 'deletes an existing patient' do
        patient = create(:patient, name: 'Patient to Delete', email: 'delete@example.com', mobile: '1234567890')

        delete :destroy, params: { id: patient.id }
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['status'])=='SUCCESS'
        expect(json_response['message'])=='Patient Deleted Successfully'
        end

        it 'returns an error if patient not found' do
        delete :destroy, params: { id: 999 }
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['status'])=='ERROR'
        expect(json_response['message'])=='Patient not found'
        end
    end
end
