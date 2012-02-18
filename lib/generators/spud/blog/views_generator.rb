require 'rails/generators/migration'

class Spud::Blog::ViewsGenerator < ::Rails::Generators::Base
  
  source_root File.expand_path('../../../../../app/views', __FILE__)

  def install
    if Spud::Blog.config.blog_enabled
      copy_file 'blog/_comment.html.erb', 'app/views/blog/_comment.html.erb'
      copy_file 'blog/_comment_form.html.erb', 'app/views/blog/_comment_form.html.erb'
      copy_file 'blog/index.html.erb', 'app/views/blog/index.html.erb'
      copy_file 'blog/show.html.erb', 'app/views/blog/show.html.erb'
    end
    if Spud::Blog.config.news_enabled
      copy_file 'news/index.html.erb', 'app/views/news/index.html.erb'
      copy_file 'news/show.html.erb', 'app/views/news/show.html.erb'
    end
  end
end