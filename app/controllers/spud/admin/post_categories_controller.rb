class Spud::Admin::PostCategoriesController < Spud::Admin::ApplicationController

	layout false
	respond_to :html, :json

	before_filter :find_category, :only => [:show, :edit, :update, :destroy]
	cache_sweeper :spud_post_category_sweeper, :only => [:create, :update, :destroy]

	def index
		@post_categories = SpudPostCategory.grouped
		respond_with @post_categories
	end

	def edit
		respond_with @post_category
	end

	def update
		if @post_category.update_attributes(params[:spud_post_category])
			flash[:notice] = 'Post Category was successfully updated'
			respond_with @post_category, :location => spud_admin_post_categories_path
		else
			render 'new', :status => 422
		end
	end

	def new
		@post_category = SpudPostCategory.new
		respond_with @post_category
	end

	def create
		@post_category = SpudPostCategory.new(params[:spud_post_category])
		if @post_category.save
			flash[:notice] = 'Post Category was successfully created'
			respond_with @post_category, :location => spud_admin_post_categories_path
		else
			render 'new', :status => 422
		end
	end

	def destroy
		if @post_category.destroy
			flash[:notice] = 'Post Category was successfully deleted'
			@post_categories = SpudPostCategory.grouped
			render 'index'
		else
			respond_with @post_category, :location => spud_admin_post_categories_path
		end
	end

	private

	def find_category
		@post_category = SpudPostCategory.find(params[:id])
	end


end
