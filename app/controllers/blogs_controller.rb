class BlogsController < ApplicationController
  before_filter :super_admin, :only => [:assign_columns, :do_assign_columns]
  skip_before_filter :url_authorize, :only => [:assign_columns, :do_assign_columns]
#  caches_action :index
#  cache_sweeper :user_sweeper
  
  layout 'memoir'
  include Archives
  
  def index
    @blogs = @user.blogs.where(:is_draft => false).page(params[:page]).order("created_at DESC")
    @categories = @user.categories.order('created_at')
  end

  def show
    @blog = Blog.find(params[:id])
    if @blog.is_draft && @user.id != session[:id]
      redirect_to site @user
    else
      if @blog.user == @user
        add_view_count
        @categories = @user.categories.order('created_at')
        @new_blogs = @user.blogs.where(:is_draft => false).order('created_at DESC').limit(6)
        @blog_pre = @user.blogs.where(["category_id = ? AND created_at > ? AND is_draft = false", @blog.category_id, @blog.created_at]).order('created_at').first
        @blog_next = @user.blogs.where(["category_id = ? AND created_at < ? AND is_draft = false", @blog.category_id, @blog.created_at]).order('created_at DESC').first
        comments = @blog.blogcomments
        @all_comments = (comments | @blog.rblogs.select{|x| !(x.body.nil? or x.body.size == 0)}).sort_by{|x| x.created_at}
        @comments_uids = comments.collect{|c| c.user_id}
        ids = @user.blogs.select('id')
        @rblogs = @user.r_blogs.where(id: ids).limit(6)
        cate_ids = @user.blogs.where(:is_draft => false).where(["category_id = ?", @blog.category_id]).select('id')
        @cate_rblogs = @user.r_blogs.where(id: cate_ids).limit(5)
        if @cate_rblogs.size < 5
          @cate_blogs = @user.blogs.where(["category_id = ? AND is_draft = false", @blog.category_id]).order('created_at DESC').limit(5 - @cate_rblogs.size)
        end
        archives_months_count
        #TODO UNIQUE @cate_blogs AND @cate_rblogs
        if @m
          render mr, layout: 'm/portal'
        else
          render layout: 'blog'
        end
      else
        r404
      end
    end
  end

  def new
    if session[:id] == @user.id
      @blog = Blog.new
      render mr, layout: 'm/portal' if @m
    else
      r404
    end
  end

  def edit
    @blog = Blog.find(params[:id])
    @tags = @blog.tags.map { |t| t.name }.join(" ")
    authorize @blog
    render mr, layout: 'm/portal' if @m
  end

  def create
    @blog = Blog.create(params[:blog])
    @blog.user_id = session[:id]
    if params[:category_name].nil?
      create_proc
    else
      @category = Category.new
      @category.name = params[:category_name]
      @category.user_id = session[:id]
      if @category.save
        @blog.category_id = @category.id
        create_proc
      else
        if @category.name == ""
          flash[:error] = t'category.name_must_notnull'
        else
          flash[:error] = t('taken',w: @category.name)
        end
        _render :new
      end
    end
  end

  def create_proc
    build_tags @blog
    if @blog.save
      if @blog.is_draft
        flash[:notice2] = t'blog_drafted'
      else
        flash[:notice2] = t'blog_posted'
      end
#      expire_action :action => :index
      send_weibo
      send_qq
      redirect_to blog_path(@blog)
    else
      _render :new
    end
  end

  def update
    @blog = Blog.find(params[:id])
    if @blog.update_attributes(params[:blog])
      @blog.tags.destroy_all
      build_tags @blog
      @blog.update_attributes(params[:blog])
      if @blog.is_draft
        flash[:notice2] = t'blog_drafted_update_succ'
      else
        flash[:notice2] = t'update_succ'
      end
      redirect_to blog_path
    else
      _render :edit
    end
  end

  def build_tags(item)
    unless params[:tags].to_s == ''
      tags_a = params[:tags].split ' '
      tags_a.uniq.reverse.each do |tag|
        _tag = item.tags.build
        _tag.name = tag
      end
    end
  end

  def destroy
    @blog = Blog.find(params[:id])
    @blog.destroy
    redirect_to blogs_path, notice: t('delete_succ')
  end

  def click_show_blog
    @blog = Blog.find(params[:id])
    add_view_count
    @blog.content = summary_comment_style(@blog, 4000)
    render json: @blog.as_json()
  end  

  def archives
    #ISSUE to_char maybe only work in postgresql
    @items = @user.blogs.where(:is_draft => false).select("to_char(created_at, 'YYYYMM') as t_date, count(id) as t_count").group("to_char(created_at, 'YYYYMM')").order('t_date DESC')
  end

  def month
    @blogs = @user.blogs.where("to_char(created_at, 'YYYYMM') = ? and is_draft = false", params[:month]).page(params[:page])
    archives
  end

  def lovezhangtingting
    params[:id] = 2
    show
    render :show
  end

  def assign_columns
    @blog = Blog.find(params[:id])
    @columns = @blog.columns
    @all_columns = Column.order("created_at").limit(6)
    render layout: 'help'
  end

  def do_assign_columns
    blog = Blog.find(params[:id])
    blog.columns.destroy_all
    unless params[:column].nil?
      params[:column].each do |k|
        blog.columns << Column.find(k)
      end
    end
    redirect_to column_blogs_path, notice: t('succ', w: t('assign_columns'))
  end

  #not used
  def latest_attention
    @columns = Column.order("created_at").limit(6)
    @blogs = Blog.where('replied_at is not null and is_draft = false').page(params[:page]).order("replied_at DESC")
    render layout: 'column'
  end

  def hotest
    #TODO FILTER 'replied_at is not null'
    @columns = Column.order("created_at").limit(6)
    @blogs = Blog.where(:is_draft => false).page(params[:page]).order("comments_count DESC")
    notes = Note.where(:is_draft => false).page(params[:page]).order("comments_count DESC")
    @all = (@blogs | notes).sort_by{|x| x.comments_count}.reverse!
    render layout: 'column'
  end

  private
  def send_weibo
    #TODO  UPDATE FROM IS_DRAFT TO FALSE HAVN'T DO SEND.
    if session[:atoken] and @blog.is_draft==false
      begin
        oauth = weibo_auth
        str = "#{@blog.title} - "
        data = "#{str}#{text_it_pure(@blog.content)[0..130-str.size]}#{site(@user) + blog_path(@blog)}"
        Weibo::Base.new(oauth).update(data)
      rescue
        logger.warn("---Send_blog_to_weibo blog.id=#{@blog.id} failed.Data is #{data} #{session[:atoken]}")
      end
    end
  end

  def send_qq
    if session[:token] and @blog.is_draft==false
      begin
        qq = Qq.new
        auth = qq.gen_auth(session[:token], session[:openid])
        text = text_it_pure(@blog.content)
        url = site(@user) + blog_path(@blog)
        comment = text[0..40]
        summary = "...#{text[41..160]}"
        #TODO image pengyou.com no data.来自不对
        qq.add_share(auth, @blog.title, url, comment, summary, "", '1', site(@user), '', '')



        #        str = "#{@blog.title} - "
        #        data = "#{str}#{text[0..130-str.size]}#{url}"
        #        qq.add_t(auth, '', '', '', '1', "testweibohaihihihih")
        #        def add_share(auth,title,url,comment,summary,images,source,site,nswb,*play)
        #          data=auth + '&title=' + title + '&url=' + url + '&comment=' + comment + '&summary=' + summary + '&images=' + images + '&source=' + source + '&site=' + site + '&nswb=' + nswb + '&type=' + play[0]
        #          data=data + '&playurl=' + play[1] unless play.count ==1
        #          MultiJson.decode(post_comm(ADDSHAREURL,URI.escape(data)))
        #        end
      rescue
        logger.warn("---Send_blog_to_qq blog.id=#{@blog.id} failed.Data is #{url}, #{comment}, #{summary}, #{auth} ")
      end
    end
  end

  def add_view_count
    @blog.views_count = @blog.views_count + 1
    Blog.update_all("views_count = #{@blog.views_count}", "id = #{@blog.id}")
  end
end