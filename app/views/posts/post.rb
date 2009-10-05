class Posts::Post < Mustache::Rails
  def initialize(post)
    @post = post
  end

  def title
    debugger
    link_to @post.title, @post
  end

  def body
    simple_format @post.body
  end
end
