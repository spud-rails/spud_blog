class Spud::Admin::PostCategoriesController < Spud::Admin::ApplicationController

	layout 'spud/admin/post'
	respond_to :html, :xml, :json
	before_filter :find_category, :only => [:show, :edit, :update, :destroy]
	add_breadcrumb 'Post Categories', :spud_admin_post_categories_path

	belongs_to_spud_app :post_categories

	def index
		@post_categories = SpudPostCategory.order('name asc').includes(:posts).paginate(:page => params[:page], :per_page => 15)
		respond_with @post_categories
	end

	def edit
		respond_with @post_category
	end

	def update
		flash[:notice] = 'Post Category was successfully updated' if @post_category.update_attributes(params[:spud_post_category])
		respond_with @post_category, :location => spud_admin_post_categories_path
	end

	def new
		@post_category = SpudPostCategory.new
		respond_with @post_category
	end

	def create
		@post_category = SpudPostCategory.new(params[:spud_post_category])
		flash[:notice] = 'Post Category was successfully created' if @post_category.save
		respond_with @post_category, :location => spud_admin_post_categories_path
	end

	def destroy
		flash[:notice] = 'Post Category was successfully deleted' if @post_category.destroy
		respond_with @post_category, :location => spud_admin_post_categories_path
	end

	private

	def find_category
		@post_category = SpudPostCategory.find(params[:id])
	end

end