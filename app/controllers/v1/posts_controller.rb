# frozen_string_literal: true

module V1
  #
  #  post controller
  #
  class PostsController < ApplicationController
    before_action :set_post, only: %i[show update destroy]

    def index
      posts = Post.order(created_at: :desc).limit(20)
      render json: { status: "success", data: posts }
    end

    def show
      render json: { status: "success", data: @post }
    end

    def create
      post = Post.new(post_params)
      if post.save
        render json: { status: "success", data: post }
      else
        render json: { status: "error", data: post.errors }
      end
    end

    def update
      if @post.update(post_params)
        render json: { status: "success", data: @post }
      else
        render json: { status: "error", data: @post.errors }
      end
    end

    def destroy
      # TODO
    end

    private

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.permit(:subject, :body)
    end
  end
end
