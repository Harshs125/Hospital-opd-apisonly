class Api::V1::TestsController < ApplicationController
    include AdminAuthentication


    def create
        test=Test.new(test_params)
        if test.save
            render json:{status:'SUCCESS',message:'successfully added Test in hospital ',data:test},status: :ok
        else
            render json: {status: 'ERROR', message: 'Test cannot be added',data:test.errors},status: :unprocessable_entity
        end
    end

    def index
        tests=Test.all
        render json:{status:'SUCCESS',message:'List of all Tests',data:tests},status: :ok
    end

    def show
        test = Test.find(params[:id])
        render json: { status: 'SUCCESS', message: 'Loaded Test', data: test }, status: :ok
    rescue ActiveRecord::RecordNotFound
        render json: { status: 'ERROR', message: 'Test not found', data: {} }, status: :not_found
    end

    def update
        test = Test.find(params[:id])
        if test.update(test_params)
          render json: { status: 'SUCCESS', message: 'Test updated', data: test }, status: :ok
        else
          render json: { status: 'ERROR', message: 'Update failed', data: test.errors }, status: :unprocessable_entity
        end
    rescue ActiveRecord::RecordNotFound
        render json: { status: 'ERROR', message: 'Test not found', data: {} }, status: :not_found
    end

    def destroy
        test = Test.find(params[:id])
        test.destroy
        render json: { status: 'SUCCESS', message: 'Test removed', data: {} }, status: :ok
    rescue ActiveRecord::RecordNotFound
        render json: { status: 'ERROR', message: 'Test not found', data: {} }, status: :not_found
    end

    
    def test_params
        params.require(:test).permit(:name,:price)
    end

end
