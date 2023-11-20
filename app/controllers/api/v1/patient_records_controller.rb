class Api::V1::PatientRecordsController < ApplicationController
    include DoctorAuthentication
    before_action :set_patient_record, only: [:show,:update,:destroy]
    def index
        patient=Patient.find(params[:patient_id])
        patient_records=patient.patient_records
        render json:{status:'SUCCESS',message:"Loaded all patient records",data:patient_records},status: :ok
    end

    def show
        render json: {status:"SUCCESS",message:"Loaded Patient Record",data:@patient_record},status: :ok
    end

    def create
        patient=Patient.find(params[:patient_id])
        patient_record=patient.patient_records.new(patient_record_params)
        patient_record['diagnosed_by']=@current_user['id']
        if patient_record.save
            render json: {status: 'SUCCESS', message: 'Patient record created successfully ',data:patient_record},status: :ok
        else
            render json: {status: 'ERROR', message: 'Patient record creation failed',data:patient_record.errors},status: :unprocessable_entity
        end
    end 

    def update
        if @patient_record.update(patient_record_params)
            render json: {status:'SUCCESS', message:"Patient record updated",data:@patient_record},status: :ok
        else
            render json: {status:"ERROR",message:"Update Failed",data:@patient_record.errors},status: :unprocessable_entity
        end
    end

    def destroy
        @patient_record.destroy
        render json: { status: 'SUCCESS', message: 'Patient record deleted', data: {} }, status: :ok
    end

    private

    def set_patient_record
        @patient_record = PatientRecord.find(params[:id])
        rescue ActiveRecord::RecordNotFound
        render json: { status: 'ERROR', message: 'Patient record not found', data: {} }, status: :not_found
    end

    def patient_record_params
        params.require(:patient_record).permit(:patient_id, :diagnosed_with, :diagnosed_by, :prescription,:vaccine_id, :test_id, :service_id)
    end
end
