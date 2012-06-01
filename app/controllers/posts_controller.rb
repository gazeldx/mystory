class PostsController < ApplicationController
  layout 'help'

  def new
    @post = Post.new
#    puts request.env["HTTP_REFERER"]
#    puts request.env["HTTP_REFERER"].match(/.*\/(\d{1,})$/)
#    puts request.env["HTTP_REFERER"].match(/.*\/(\d{1,})$/)[1]
    @post.board_id = request.env["HTTP_REFERER"].match(/.*\/(\d{1,})$/)[1]
    @board = Board.find(@post.board_id)
  end

  def create
    @post = Post.create(params[:post])
    @post.user_id = session[:id]
    @post.replied_at = Time.now
    if @post.save
      flash[:notice] = t'post_posted'
      redirect_to sub_site("bbs") + "/#{@post.board_id.to_s}"
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
    if request.subdomain == 'bbs' or @post.user == @user
      @all_comments = @post.postcomments.order('likecount DESC, created_at')
      @comments_uids = @all_comments.collect{|c| c.user_id}
      render layout: 'post_share'
    else
      r404
    end
  end

  def my
    @posts = Post.where("user_id = ?", session[:id]).includes([:postcomments, :board]).page(params[:page]).order('id DESC')
  end

  def my_reply
    @postcomments = Postcomment.where("user_id = ?", session[:id]).includes(:post => [:user, :board, :postcomments]).page(params[:page]).order('id DESC')
  end

  def bbs
    @fboards = @user.fboards.includes(:board).order('created_at')
    @posts = @user.posts.includes([:postcomments, :board]).page(params[:page]).order('id DESC')
    render layout: 'memoir'
  end

  def reply
    @fboards = @user.fboards.includes(:board).order('created_at')
    @postcomments = @user.postcomments.includes(:post => [:user, :board, :postcomments]).page(params[:page]).order('id DESC')
    render layout: 'memoir'
  end
  
  # GET /posts
  # GET /posts.json
  def index
    #@posts = Post.all
    #@posts = Post.paginate(:page => params[:page])
    @posts = Post.page(params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :ok }
    end
  end
end
