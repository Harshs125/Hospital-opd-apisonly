module AdminAuthentication
    extend ActiveSupport::Concern
  
    included do
      before_action :authenticate_admin
    end
  
    def authenticate_admin
      puts  "---->>>>  debug #{@current_user['id']}"
      role= @current_user['role']
      if current_user && role=="admin"
      else
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    end
  end
  