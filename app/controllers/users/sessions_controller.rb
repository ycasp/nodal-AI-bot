class Users::SessionsController < Devise::SessionsController

  def create
    homepage_login = params[:user][:from_homepage] == "true"
    # self.resource = resource_class.new(sign_in_params)
    self.resource = resource_class.new(sign_in_params)
    resource = warden.authenticate(auth_options)
    if resource
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      redirect_to products_path
    else
      flash[:alert] = "Wrong login credidentials!"
      if homepage_login
        @resource = self.resource
        @resource_name = resource_name
        @devise_mapping = Devise.mappings[:user]
        render "pages/home", status: :unprocessable_entity
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

end
