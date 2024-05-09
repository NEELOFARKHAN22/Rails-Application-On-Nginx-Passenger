class ApplicationController < ActionController::Base

    before_action :configure_permitted_parameters, if: :devise_controller?
      before_action  :set_query

      def set_query
          @query = User.ransack(params[:q])
      end
    protected
  
    def configure_permitted_parameters

      attributes = [:name, :image]
      devise_parameter_sanitizer.permit(:account_update, keys: attributes)
      devise_parameter_sanitizer.permit(:sign_up, keys: [:fname, :lname,:image,:avatar,:images])
      devise_parameter_sanitizer.permit(:update, keys: [:fname, :lname,:image,:avatar,:images])


end



end
