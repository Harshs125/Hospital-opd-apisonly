module DoctorAuthentication
    extend ActiveSupport::Concern
  
    included do
      before_action :authenticate_doctor
    end
  
    def authenticate_doctor
      puts "______>>>>>>>> #{@current_user['role']}"
      role= @current_user['role']
      if !@current_user['is_valid']
        render json:{error:"sorry Your temproraily suspended by the admin"}
      if current_user && role=="doctor"
      else
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    end
  end
  