# frozen_string_literal: true

module V1
  #
  #  post controller
  #
  class PostsController < ApplicationController
    before_action :set_post, only: %i[show update destroy]

    def index
      posts = Post.order(created_at: :desc).limit(20)
      render json: posts
    end

    def show
      render json: @post
    end

    def create
      post = Post.new(post_params)
      if post.save
        render json: post
      else
        render json: { error: post.errors }
      end
    end

    def update
      if @post.update(post_params)
        render json: @post
      else
        render json: { error: @post.errors }
      end
    end

    def destroy
      @post.destroy
      render json: @post
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
