class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  include Devise::Controllers::Helpers

  def home
    @resource = User.new
    @resource_name = :user
    @devise_mapping = Devise.mappings[:user]
  end
end
