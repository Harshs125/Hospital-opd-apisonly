class Api::V1::DoctorsController < ApplicationController
    def create
        doctor=Doctor.new(doctor_params)
        if doctor.save
            render json:{status:'SUCCESS',message:'You are successfully registered',data:doctor},status: :ok
        else
            render json: {status: 'ERROR', message: 'Registration failed',data:doctor.errors},status: :unprocessable_entity
        end
    end

    def index
        doctors=Doctor.all
        puts "-------->>>>>>>>>>"
        render json:{status:'SUCCESS',message:'List of all Doctors',data:doctors},status: :ok
    end

    def show
        doctor = Doctor.find(params[:id])
        render json: { status: 'SUCCESS', message: 'Loaded doctor', data: doctor }, status: :ok
    rescue ActiveRecord::RecordNotFound
        render json: { status: 'ERROR', message: 'Doctor not found', data: {} }, status: :not_found
    end

    def update
        doctor = Doctor.find(params[:id])
        if doctor.update(doctor_params)
          render json: { status: 'SUCCESS', message: 'Doctor updated', data: doctor }, status: :ok
        else
          render json: { status: 'ERROR', message: 'Update failed', data: doctor.errors }, status: :unprocessable_entity
        end
    rescue ActiveRecord::RecordNotFound
        render json: { status: 'ERROR', message: 'Doctor not found', data: {} }, status: :not_found
    end

    def destroy
        doctor = Doctor.find(params[:id])
        doctor.destroy
        render json: { status: 'SUCCESS', message: 'Doctor deleted', data: {} }, status: :ok
    rescue ActiveRecord::RecordNotFound
        render json: { status: 'ERROR', message: 'Doctor not found', data: {} }, status: :not_found
    end

    
    def doctor_params
        params.require(:doctor).permit(:name,:email,:mobile,:timing_from,:timing_to,specialization:[])
    end
end
