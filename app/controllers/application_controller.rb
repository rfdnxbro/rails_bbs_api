# frozen_string_literal: true

#
# controllerのsuperクラス
#
class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  rescue_from Pundit::NotAuthorizedError, with: :render_403
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  before_action :configure_permitted_parameters, if: :devise_controller?
  include Pundit

  def render_404
    render status: 404, json: { message: "record not found." }
  end

  def render_403
    render status: 403, json: { message: "You don't have permission." }
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def pundit_user
    current_v1_user
  end
end
