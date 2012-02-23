require 'rails/generators/migration'

class Spud::Blog::RandomPostsGenerator < ::Rails::Generators::Base

  def generate
    if Spud::Blog.config.blog_enabled
      puts 'Generating random blog posts...'
      random_posts(false)
    end
    if Spud::Blog.config.news_enabled
      puts 'Generating random news posts...'
      random_posts(true)
    end
    puts 'Assigning categories...'
    category_ids = SpudPostCategory.all.collect{ |c| c.id }
    SpudPost.all.each do |p|
      p.category_ids = [category_ids[rand(category_ids.length)]]
      p.save
    end
    puts 'Done!'
  end

  private

  def random_posts(is_news)
    100.times do
      post = SpudPost.create({
        :title => random_title,
        :content => random_content,
        :published_at => random_time,
        :visible => 1,
        :spud_user_id => 1,
        :is_news => is_news
      })
    end
  end

  def random_word
    chars = 'abcdefghjkmnpqrstuvwxyz'
    length = rand(8) + 1
    return (1..length).collect{ chars[rand(chars.length)] }.join('')
  end

  def random_title
    return (1..4).collect{ random_word.capitalize }.join(' ')
  end

  def random_content
    content = ''
    3.times do |i|
      content += '<p>' + (1..30).collect{ random_word }.join(' ').capitalize + '.</p>'
    end
    return content
  end

  def random_time
    return Time.at(1.year.ago + rand * (Time.now.to_f - 1.year.ago.to_f))
  end

end