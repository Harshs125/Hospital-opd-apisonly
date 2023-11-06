# spec/controllers/api/v1/doctors_controller_spec.rb

require 'rails_helper'

RSpec.describe Api::V1::DoctorsController, type: :controller do
    describe 'POST #create' do
        it ' create a doctor' do 
            byebug
            doctor_params = FactoryBot.attributes_for(:doctor)
            post :create, params: { doctor: doctor_params }
            
            expect(response).to have_http_status(:ok)
        end
    end 
end
