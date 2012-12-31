class PostsController < ApplicationController
  layout 'help'

  def new
    @post = Post.new
    @post.board_id = request.env["HTTP_REFERER"].match(/.*\/(\d{1,})$/)[1]
    @board = Board.find(@post.board_id)
    if @m
      render mr, :layout => 'm/portal'
    else
      render :layout => 'post_new'
    end
  end

  def create
    @post = Post.create(params[:post])
    @post.user_id = session[:id]
    @post.replied_at = Time.now
    if @post.save
      flash[:notice] = t'post_posted'
      send_weibo
      send_qq
      redirect_to m_or(sub_site("bbs") + "/#{@post.board_id.to_s}")
    else
      @board = Board.find(@post.board_id)
      _render :new
    end
  end

  def show
    @post = Post.find(params[:id])
    if request.subdomain == 'bbs' or request.subdomain == 'bbs.m' or @post.user == @user
      @all_comments = @post.postcomments.order('likecount DESC, created_at')
      @comments_uids = @all_comments.collect{|c| c.user_id}
      if @m
        render mr, :layout => 'm/portal'
      else
        render :layout => 'post_share'
      end
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
    render :layout => 'memoir'
  end

  def reply
    @fboards = @user.fboards.includes(:board).order('created_at')
    @postcomments = @user.postcomments.includes(:post => [:user, :board, :postcomments]).page(params[:page]).order('id DESC')
    render :layout => 'memoir'
  end
  
  private
  def send_weibo
    if weibo_active?
      begin
        oauth = weibo_auth
        str = "#{@post.title + ' - '}"
        data = "#{str}#{text_it_pure(@post.content)[0..130-str.size]}#{site(@user)}/p/#{@post.id}"
        Weibo::Base.new(oauth).update(data)
      rescue
        logger.warn("---Send_post_to_weibo post.id=#{@post.id} failed.Data is #{data} #{session[:atoken]} ")
      end
    end
  end

  def send_qq
    if qq_active?
      begin
        qq = Qq.new
        auth = qq.gen_auth(session[:token], session[:openid])
        text = text_it_pure(@post.content)
        url = "#{site(@user)}/p/#{@post.id}"
        comment = text[0..40]
        summary = "...#{text[41..160]}"
        qq.add_share(auth, @post.title, url, comment, summary, "", '1', site(@user), '', '')
      rescue
        logger.warn("---Send_post_to_qq post.id=#{@post.id} failed.Data is #{url}, #{comment}, #{summary}, #{auth} ")
      end
    end
  end
end
