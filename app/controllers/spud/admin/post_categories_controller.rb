class Spud::Admin::PostCategoriesController < Spud::Admin::ApplicationController

	respond_to :html, :xml, :json
	before_filter :find_category, :only => [:show, :edit, :update, :destroy]

	belongs_to_spud_app :posts

	def index
		@post_categories = SpudPostCategory.all
		respond_with @post_categories
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

	def find_category
		@post_category = SpudPostCategory.find(params[:id])
	end

end