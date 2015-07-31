class Blogs::PostsController < BlogsController

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end
end