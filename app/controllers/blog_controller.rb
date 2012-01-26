class BlogController < ApplicationController

	respond_to :html, :xml, :json
	before_filter :find_post, :only => [:show, :create_comment]
	layout Spud::Blog.default_layout

  def index
  	@posts = SpudPost.where('visible = 1 AND published_at <= ?', DateTime.now).order('published_at desc').includes(:comments, :categories).paginate(:page => params[:page], :per_page => 5)
  	respond_with @posts
  end

  def show
  	respond_with @post
  end

  def create_comment
    return unless params[:comment_validation].empty? # trap spam bots
    @comment = @post.comments.new(params[:blog_comment])
    flash[:notice] = 'Your comment has been posted, however it will not appear until it is approved.' if @comment.save
    respond_with @comment do |format|
    	format.html { redirect_to spud_post_path(@post, :anchor => 'spud_post_comment_form') }
    end
  end 

  private 

  def find_post
  	@post = SpudPost.find(params[:id])
		if @post.blank? || @post.is_private?
			flash[:error] = "Post not found!"
			redirect_to blog_path and return false
		end
  end

end