class Api::V1::PatientsController < ApplicationController
    before_action :set_patient,only: [:show,:update,:destroy]
    
    def index
        patients=Patient.all
        render json:{status:'SUCCCESS', message:'Loaded all patients',data:patients},status: :ok
    end

    def show
        render json:{status:'SUCCESS', message:'Loaded patient',data:@patient},status: :ok
    end

    def create
        patient = Patient.new(patient_params)

        if patient.save
            render json:{status:"SUCCESS",message:"Patient created successfully" , data:patient},status: :ok
        else
            render json:{status:"ERROR",message:"Patient creation failed" , data:patient.errors},status: :unprocessable_entity
        end
    end

    def update
        if @patient.update(patient_params)
            render json: {status:'SUCCESS',message:"Patient updated",data:@patient},status: :ok
        else 
            render json: {status:'ERROR',message:"Update failed",data:@patient.errors},status: :unprocessable_entity
        end
    end

    def destroy
        @patient.destroy
        render json: {status:'SUCCESS',message:"Patient Deleted Successfully"},status: :ok
    end

    private
    
    def set_patient
        @patient = Patient.find(params[:id])
    rescue
        render json: {status:"ERROR",message:'Patient Not Found',data:{}},status: :not_found
    end

    def patient_params
        params.require(:patient).permit(:name, :email, :mobile)
      end
end
