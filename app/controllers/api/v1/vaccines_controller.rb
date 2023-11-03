class Api::V1::VaccinesController < ApplicationController
    include AdminAuthentication


    def create
        vaccine=Vaccine.new(vaccine_params)
        if vaccine.save
            render json:{status:'SUCCESS',message:'successfully added vaccine in hospital ',data:vaccine},status: :ok
        else
            render json: {status: 'ERROR', message: 'vaccine cannot be added',data:vaccine.errors},status: :unprocessable_entity
        end
    end

    def index
        vaccines=Vaccine.all
        render json:{status:'SUCCESS',message:'List of all vaccines',data:vaccines},status: :ok
    end

    def show
        vaccine = Vaccine.find(params[:id])
        render json: { status: 'SUCCESS', message: 'Loaded vaccine', data: vaccine }, status: :ok
    rescue ActiveRecord::RecordNotFound
        render json: { status: 'ERROR', message: 'vaccine not found', data: {} }, status: :not_found
    end

    def update
        vaccine = Vaccine.find(params[:id])
        if vaccine.update(vaccine_params)
          render json: { status: 'SUCCESS', message: 'vaccine updated', data: vaccine }, status: :ok
        else
          render json: { status: 'ERROR', message: 'Update failed', data: vaccine.errors }, status: :unprocessable_entity
        end
    rescue ActiveRecord::RecordNotFound
        render json: { status: 'ERROR', message: 'vaccine not found', data: {} }, status: :not_found
    end

    def destroy
        vaccine = Vaccine.find(params[:id])
        vaccine.destroy
        render json: { status: 'SUCCESS', message: 'vaccine removed', data: {} }, status: :ok
    rescue ActiveRecord::RecordNotFound
        render json: { status: 'ERROR', message: 'vaccine not found', data: {} }, status: :not_found
    end

    
    def vaccine_params
        params.require(:vaccine).permit(:name,:price)
    end

end
