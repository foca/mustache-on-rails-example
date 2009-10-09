class Posts::Show < Mustache::Rails
  def title
    @post.title
  end

  def url
    url_for @post
  end

  def body
    simple_format @post.body
  end

  def edit_path
    url_for [:edit, @post]
  end

  def comments?
    not _valid_comments.empty?
  end

  def comments
    _valid_comments.map do |comment|
      { :comment => comment.body }
    end
  end

  def _valid_comments
    @post.comments.reject(&:new_record?)
  end
end
