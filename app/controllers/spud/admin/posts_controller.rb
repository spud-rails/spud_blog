class Spud::Admin::PostsController < ApplicationController

	respond_to :html, :xml, :json
	before_filter :find_post, :only => [:show, :edit, :update, :destroy]

	def index

	end

	def show

	end

	def edit

	end

	def update
		
	end

	def new

	end

	def create

	end

	def destroy

	end

	private

	def find_post
		@post = SpudPost.find(params[:id])
	end

end
