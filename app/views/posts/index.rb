class Posts::Index < Mustache::Rails
  def posts
    @posts.map do |post|
      { :title => link_to(post.title, post),
        :body  => simple_format(post.body) }
    end
  end
end
