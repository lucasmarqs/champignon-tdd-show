class Blogs::PostsController < BlogsController

  def index
    @posts = Post.all
  end
end