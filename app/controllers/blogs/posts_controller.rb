class Blogs::PostsController < BlogsController
  before_action :set_post, only: [:show, :edit, :update]

  before_action :authenticate_user!, only: [:create, :new, :edit]

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to blogs_root_path
    else
      render :new
    end
  end

  def show; end

  def edit
    render :index if current_user.id != @post.user.id
  end

  def update
    if @post.update(post_params)
      redirect_to blogs_path @post
    else
      render :edit
    end
  end

  private
  def post_params
    params.require(:post).permit(:title, :content, :user_id)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end