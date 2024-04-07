# app/controllers/contents_controller.rb
module Api
  module V1
    class ContentsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_content, only: [:show, :update, :destroy]

      def index
        @contents = Content.all
        render json: @contents
      end

      def show
        render json: @content
      end

      def create
        @content = current_user.contents.build(content_params)
        if @content.save
          render json: @content, status: :created
        else
          render json: @content.errors, status: :unprocessable_entity
        end
      end

      def update
        if @content.user == current_user && @content.update(content_params)
          render json: @content
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
        params.require(:content).permit(:title, :body)
      end
    end
  end
end