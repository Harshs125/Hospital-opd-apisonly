require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Doctors" do
  explanation 'API for managing doctors functionality'
  header 'Content-Type', 'application/json'
  header 'Accept' , 'application/json'

  let!(:user) { create(:user, email: 'test@example.com', password: 'password123', role: 'admin') }
  let(:jwt_token) { JWT.encode({ sub: user.id, role: 'admin' }, Rails.application.credentials.fetch(:secret_key_base), 'HS256', exp: 30.minutes.to_i) }
  let(:authorization_header) { "Bearer #{jwt_token}" }

  let(:valid_doctor_id) {1}


  post '/api/v1/doctors' do
    parameter :doctor, 'Doctor parameters', required: true

    # let(:doctor_params) { FactoryBot.attributes_for(:doctor) }

    example 'creates a new doctor' do
      do_request()
      byebug
      expect(response_status).to eq 200
      expect(JSON.parse(response_body)['status']).to eq('SUCCESS')
    end
  end
end