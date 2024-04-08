# app/controllers/contents_controller.rb
module Api
  module V1
    class ContentsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_content, only: [:show, :update, :destroy]

      def index
        @contents = Content.all
        render json: ContentSerializer.new(@contents).serializable_hash.to_json
      end

      def show
        render json: ContentSerializer.new(@content).serializable_hash.to_json
      end

      def create
        @content = current_user.contents.build(content_params)
        if @content.save
          render json: ContentSerializer.new(@content).serializable_hash.to_json, status: :created
        else
          render json: @content.errors, status: :unprocessable_entity
        end
      end

      def update
        if @content.user == current_user && @content.update(content_params)
          render json: ContentSerializer.new(@content).serializable_hash.to_json
        else
          render json: { error: "You are not authorized to update this content" }, status: :unauthorized
        end
      end

      def destroy
        if @content.user == current_user
          @content.destroy
          render json: { message: "Content deleted successfully" }, status: :ok
        else
          render json: { error: "You are not authorized to delete this content" }, status: :unauthorized
        end
      end

      private

      def set_content
        @content = Content.find(params[:id])
      end

      def content_params
        params.permit(:title, :body)
      end
    end
  end
end