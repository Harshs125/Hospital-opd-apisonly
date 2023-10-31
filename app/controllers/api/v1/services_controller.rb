class Api::V1::ServicesController < ApplicationController
    def create
        service=Service.new(service_params)
        if service.save
            render json:{status:'SUCCESS',message:'successfully added service in hospital ',data:service},status: :ok
        else
            render json: {status: 'ERROR', message: 'service cannot be added',data:service.errors},status: :unprocessable_entity
        end
    end

    def index
        services=Service.all
        render json:{status:'SUCCESS',message:'List of all services',data:services},status: :ok
    end

    def show
        service = Service.find(params[:id])
        render json: { status: 'SUCCESS', message: 'Loaded service', data: service }, status: :ok
    rescue ActiveRecord::RecordNotFound
        render json: { status: 'ERROR', message: 'service not found', data: {} }, status: :not_found
    end

    def update
        service = Service.find(params[:id])
        if service.update(service_params)
          render json: { status: 'SUCCESS', message: 'service updated', data: service }, status: :ok
        else
          render json: { status: 'ERROR', message: 'Update failed', data: service.errors }, status: :unprocessable_entity
        end
    rescue ActiveRecord::RecordNotFound
        render json: { status: 'ERROR', message: 'service not found', data: {} }, status: :not_found
    end

    def destroy
        service = Service.find(params[:id])
        service.destroy
        render json: { status: 'SUCCESS', message: 'service removed', data: {} }, status: :ok
    rescue ActiveRecord::RecordNotFound
        render json: { status: 'ERROR', message: 'service not found', data: {} }, status: :not_found
    end

    
    def service_params
        params.require(:service).permit(:name,:price)
    end
end
