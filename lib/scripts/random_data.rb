# Quick script for faking up some data

def random_word
  chars = 'abcdefghjkmnpqrstuvwxyz'
  return (1..6).collect{ chars[rand(chars.length)] }.join('').capitalize
end

def random_title
  return (1..4).collect{ random_word }.join(' ')
end

def random_time
  return Time.at(1.year.ago + rand * (Time.now.to_f - 1.year.ago.to_f))
end

100.times do
  post = SpudPost.create({
    :title => random_title,
    :content => 'Hello, World!',
    :published_at => random_time,
    :visible => 1,
    :spud_user_id => 1
  })
end

category_ids = SpudPostCategory.all.collect{ |c| c.id }

SpudPost.all.each do |p|
  p.category_ids = [category_ids[rand(category_ids.length)]]
  p.save
end