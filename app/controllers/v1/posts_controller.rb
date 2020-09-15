# frozen_string_literal: true

module V1
  #
  #  post controller
  #
  class PostsController < ApplicationController
    before_action :set_post, only: %i[show update destroy]

    def index
      posts = Post.includes(:user).order(created_at: :desc).limit(20)
      authorize posts
      render json: posts
    end

    def show
      authorize @post
      render json: @post
    end

    def create
      authorize Post
      post = current_v1_user.posts.new(post_params)
      if post.save
        render json: post
      else
        render json: { errors: post.errors }, status: 422
      end
    end

    def update
      authorize @post
      if @post.update(post_params)
        render json: @post
      else
        render json: { errors: @post.errors }, status: 422
      end
    end

    def destroy
      authorize @post
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
