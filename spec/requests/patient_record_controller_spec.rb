# spec/controllers/api/v1/patient_records_controller_spec.rb

require 'rails_helper'

RSpec.describe Api::V1::PatientRecordsController, type: :controller do
    let!(:user) { create(:user, email: 'test@example.com', password: 'password123',role:'doctor') }
	before do
		jwt_token = JWT.encode({ sub: user.id,role:"doctor"}, Rails.application.credentials.fetch(:secret_key_base), 'HS256',exp:30.minutes.to_i)
		request.headers['Authorization'] = "Bearer #{jwt_token}"
	end
    describe 'GET #index' do
        it 'returns a list of patient records for a specific patient' do
            patient = create(:patient)
            patient_record1 = create(:patient_record, patient: patient)
            patient_record2 = create(:patient_record, patient: patient)

            get :index, params: { patient_id: patient.id }

            expect(response).to have_http_status(:ok)
            json_response = JSON.parse(response.body)
            expect(json_response['status']).to eq('SUCCESS')
            expect(json_response['message']).to eq('Loaded all patient records')
            expect(json_response['data'].count).to eq(2)
            expect(json_response['data'][0]['diagnosed_with']).to eq(patient_record1.diagnosed_with)
            expect(json_response['data'][1]['diagnosed_by']).to eq(patient_record2.diagnosed_by)
        end
    end

    describe 'GET #show' do
        it 'returns a specific patient record' do
            patient_record = create(:patient_record)

            get :show, params: { id: patient_record.id }

            expect(response).to have_http_status(:ok)
            json_response = JSON.parse(response.body)
            expect(json_response['status']).to eq('SUCCESS')
            expect(json_response['message']).to eq('Loaded Patient Record')
            expect(json_response['data']['diagnosed_with']).to eq(patient_record.diagnosed_with)
            expect(json_response['data']['prescription']).to eq(patient_record.prescription)
        end

        it 'returns an error if patient record not found' do
            get :show, params: { id: 999 }

            expect(response).to have_http_status(:not_found)
            json_response = JSON.parse(response.body)
            expect(json_response['status']).to eq('ERROR')
            expect(json_response['message']).to eq('Patient record not found')
        end
    end

    describe 'POST #create' do
        it 'creates a new patient record' do
            patient = create(:patient)
            doctor = create(:doctor, id: 1) # Assuming you have a doctor in your system with id 1
            allow(controller).to receive(:current_user).and_return(doctor)

            post :create, params: { patient_id: patient.id, patient_record: attributes_for(:patient_record) }

            expect(response).to have_http_status(:ok)
            json_response = JSON.parse(response.body)
            expect(json_response['status']).to eq('SUCCESS')
            expect(json_response['message']).to eq('Patient record created successfully ')
            expect(json_response['data']['diagnosed_with']).to eq(PatientRecord.last.diagnosed_with)
            expect(json_response['data']['diagnosed_by']).to eq(doctor.id)
        end

        it 'fails to create a patient record with invalid parameters' do
            patient = create(:patient)
            doctor = create(:doctor, id: 1)
            allow(controller).to receive(:current_user).and_return(doctor)

            post :create, params: { patient_id: patient.id, patient_record: { diagnosed_with: '', diagnosed_by: doctor.id } }

            expect(response).to have_http_status(:unprocessable_entity)
            json_response = JSON.parse(response.body)
            expect(json_response['status']).to eq('ERROR')
            expect(json_response['message']).to eq('Patient record creation failed')
            expect(json_response['data']).to be_a(Hash)
            expect(json_response['data']).to have_key('diagnosed_with')
        end
    end

    describe 'PATCH #update' do
        it 'updates an existing patient record' do
            patient_record = create(:patient_record, diagnosed_with: 'Old Diagnosis')

            patch :update, params: { id: patient_record.id, patient_record: { diagnosed_with: 'New Diagnosis' } }

            expect(response).to have_http_status(:ok)
            json_response = JSON.parse(response.body)
            expect(json_response['status']).to eq('SUCCESS')
            expect(json_response['message']).to eq('Patient record updated')
            expect(json_response['data']['diagnosed_with']).to eq('New Diagnosis')
        end

        it 'fails to update a patient record with invalid parameters' do
            patient_record = create(:patient_record, diagnosed_with: 'Old Diagnosis')

            patch :update, params: { id: patient_record.id, patient_record: { diagnosed_with: '' } }

            expect(response).to have_http_status(:unprocessable_entity)
            json_response = JSON.parse(response.body)
            expect(json_response['status']).to eq('ERROR')
            expect(json_response['message']).to eq('Update Failed')
            expect(json_response['data']).to be_a(Hash)
            expect(json_response['data']).to have_key('diagnosed_with')
        end
    end

    # 
end
