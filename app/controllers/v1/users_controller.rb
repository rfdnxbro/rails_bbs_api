# frozen_string_literal: true

module V1
  #
  #  users controller
  #
  class UsersController < ApplicationController
    before_action :set_user, only: %i[show update destroy]

    def index
      users = User.order(created_at: :desc).limit(20)
      authorize users
      render json: users
    end

    def show
      authorize @user
      render json: @user
    end

    def create
      user = User.new(user_create_params)
      user[:provider] = :email
      authorize user
      if user.save
        render json: user
      else
        render json: { errors: user.errors }
      end
    end

    def update
      authorize @user
      if @user.update(user_params)
        render json: @user
      else
        render json: { errors: @user.errors }
      end
    end

    def destroy
      authorize @user
      @user.destroy
      render json: @user
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_create_params
      # createの時のみadmin権限を設定できるようにする
      params.permit(:name, :email, :admin, :password)
    end

    def user_params
      params.permit(:name, :email, :password)
    end
  end
end