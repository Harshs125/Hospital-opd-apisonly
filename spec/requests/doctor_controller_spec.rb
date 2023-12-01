# spec/controllers/api/v1/doctors_controller_spec.rb

require 'rails_helper'

RSpec.describe Api::V1::DoctorsController, type: :controller do
  let!(:user) { create(:user, email: 'test@example.com', password: 'password123',role:'admin') }
  before do
      jwt_token = JWT.encode({ sub: user.id,role:"admin"}, Rails.application.credentials.fetch(:secret_key_base), 'HS256',exp:30.minutes.to_i)
      request.headers['Authorization'] = "Bearer #{jwt_token}"
  end
  describe 'POST #create' do
    old_count=Doctor.count
    context 'when valid parameters are provided' do
      it 'creates a new doctor' do
        doctor_params = FactoryBot.attributes_for(:doctor) 
        post :create, params: { doctor: doctor_params }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['status']).to eq('SUCCESS')
        expect(Doctor.count)==old_count+1
      end
    end

    context 'when invalid parameters are provided' do
      it 'returns an error response' do
        post :create, params: { doctor: { name: 'Invalid Doctor' } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['status']).to eq('ERROR')
        expect(Doctor.count)==old_count
      end
    end
  end

  describe 'GET #index' do
    old_count=Doctor.count
    it 'returns a list of all doctors' do
      FactoryBot.create_list(:doctor, 3)
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['status']).to eq('SUCCESS')
      expect(JSON.parse(response.body)['data'].size)==old_count+3
    end
  end

  describe 'GET #show' do
    context 'when the doctor exists' do
      it 'returns the specified doctor' do
        doctor = FactoryBot.create(:doctor)
        get :show, params: { id: doctor.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['status']).to eq('SUCCESS')
        expect(JSON.parse(response.body)['data']['id']).to eq(doctor.id)
      end
    end

    context 'when the doctor does not exist' do
      it 'returns a not found response' do
        get :show, params: { id: 999 }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['status']).to eq('ERROR')
      end
    end
  end

  describe 'PUT #update' do
    context 'when valid parameters are provided' do
      it 'updates the specified doctor' do
        doctor = FactoryBot.create(:doctor)
        new_attributes = { name: 'Updated Doctor' }
        put :update, params: { id: doctor.id, doctor: new_attributes }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['status']).to eq('SUCCESS')
        expect(doctor.reload.name).to eq('Updated Doctor')
      end
    end

    context 'when invalid parameters are provided' do
      it 'returns an error response' do
        doctor = FactoryBot.create(:doctor)
        put :update, params: { id: doctor.id, doctor: { name: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['status']).to eq('ERROR')
        expect(doctor.reload.name).not_to eq(nil)
      end
    end

    context 'when the doctor does not exist' do
      it 'returns a not found response' do
        put :update, params: { id: 999, doctor: { name: 'Updated Doctor' } }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['status']).to eq('ERROR')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when the doctor exists' do
      it 'deletes the specified doctor' do
        doctor = FactoryBot.create(:doctor)
        delete :destroy, params: { id: doctor.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['status']).to eq('SUCCESS')
        expect { doctor.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the doctor does not exist' do
      it 'returns a not found response' do
        delete :destroy, params: { id: 999 }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['status']).to eq('ERROR')
      end
    end
  end

  describe 'POST #register_doctor' do
    old_count_doctor=Doctor.count
    old_count_user=User.count
    context 'when valid parameters are provided' do
      let(:doctor) { FactoryBot.create(:doctor) }
      it 'registers a new doctor' do
        post :register_doctor, params: { doctor_id:doctor.id,consultation_charge:50}
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['status']).to eq('SUCCESS')
        expect(Doctor.count)==old_count_doctor+1
        expect(User.count)==old_count_user+1
      end
    end

    context 'when invalid parameters are provided' do
      it 'returns an error response' do
        post :register_doctor, params: { doctor_id:999,consultation_charge:50}
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['status']).to eq('ERROR')
        expect(Doctor.count)==old_count_doctor
        expect(User.count)==old_count_user
      end 
    end

    context 'when the doctor already has an account' do
      it 'reactivates the existing doctor account' do
        existing_doctor = FactoryBot.create(:doctor, is_valid: false)
        post :register_doctor, params: { doctor_id: existing_doctor.id, consultation_charge: 50 }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['status']).to eq('SUCCESS')
        expect(existing_doctor.reload.is_valid).to eq(true)
      end
    end

  end

  describe 'POST #suspend_doctor' do
    context 'when the doctor exists' do
      it 'suspends the specified doctor account' do
        doctor = FactoryBot.create(:doctor, is_valid: true)
        post :suspend_doctor, params: { doctor_id: doctor.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message'])=="the doctor account is temporarily suspended by the admin"
        expect(doctor.reload.is_valid).to eq(false)
      end
    end

    context 'when the doctor does not exist' do
      it 'returns a not found response' do
        post :suspend_doctor, params: { doctor_id: 999 }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['status']).to eq('ERROR')
      end
    end
  end

  # Add more test cases for edge cases, error scenarios, etc.

end
