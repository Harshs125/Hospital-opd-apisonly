class Api::V1::InvoicesController < ApplicationController
    include DoctorAuthentication
    def generate
        cost_hash={}
        record_id= params[:id]
        patient_record=PatientRecord.find(record_id)
        test_id=patient_record['test_id']
        vaccine_id=patient_record['vaccine_id']
        service_id=patient_record['service_id']
        doctor_details=Doctor.find_by(doctor_id:current_user['id'])
        cost_hash['doctor_fee']=doctor_details['consultation_charge']
        amount=doctor_details['consultation_charge']
        patient_details=Patient.find(patient_record['patient_id'])
        patient_name=patient_details['name']
        patient_email=patient_details['email']
        if service_id
            service_details=Service.find(service_id)
            cost_hash[service_details['name']]=service_details['price']
            amount+=service_details['price']
        else
            cost_hash['services_cost']=0
        end
        if test_id
            test_details=Test.find(test_id)
            cost_hash[test_details['name']]=test_details['price']
            amount+=test_details['price']
        else
            cost_hash['tests']=0
        end
        if vaccine_id
            vaccine_detail=Vaccine.find(vaccine_id)
            cost_hash[vaccine_detail['name']]=vaccine_detail['price']
            amount+=vaccine_detail['price']
        else
            cost_hash['vaccines']=0
        end
    
        render json:{
            message:cost_hash,
            amount:amount
            },status: :ok
    end
end
