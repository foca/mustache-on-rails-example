class Posts::Show < Mustache::Rails
  def title
    link_to @post.title, @post
  end

  def body
    simple_format @post.body
  end

  def edit_link
    link_to "Edit", [:edit, @post]
  end

  def comments
    @post.comments.select(&:valid?).map do |comment|
      { :comment => simple_format(comment.body) }
    end
  end
end
