class Posts::Index < Mustache::Rails
  def posts?
    not @posts.empty?
  end

  def posts
    @posts.map do |post|
      { :title => post.title,
        :body  => simple_format(post.body),
        :url   => url_for(post) }
    end
  end

  def new_post_link
    link_to "New post", new_post_path
  end
end
