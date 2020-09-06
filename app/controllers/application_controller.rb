# frozen_string_literal: true

#
# controllerのsuperクラス
#
class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def render_404
    render status: 404, json: { status: "error", message: "record not found.", data: [] }
  end
end
