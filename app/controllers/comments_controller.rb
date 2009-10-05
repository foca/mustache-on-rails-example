class CommentsController < ApplicationController
  before_filter :load_post

  def create
    @comment = @post.comments.build(params[:comment])

    if @comment.save
      flash[:notice] = 'Thanks for your comment!'
      redirect_to @post
    else
      render :template => "posts/show"
    end
  end

private

  def load_post
    @post = Post.find(params[:post_id])
  end
end
