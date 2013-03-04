class BlogsController < ApplicationController
  before_filter :super_admin, :only => [:assign_columns, :do_assign_columns]
  before_filter :group_admin,  :only => [:assign_gcolumns, :do_assign_gcolumns]
  skip_before_filter :url_authorize, :only => [:assign_columns, :do_assign_columns]
  cache_sweeper :blog_sweeper
  
  layout 'memoir'
  
  # RSS and atom Feed.
  def feed    
    notes = @user.notes.where(:is_draft => false).limit(30).order("updated_at desc")
    blogs = @user.blogs.where(:is_draft => false).limit(20).order("updated_at desc")
    @all = (notes | blogs).sort_by{|x| x.updated_at}.reverse!    

    respond_to do |format|
      format.atom { render :layout => false }
      # we want the RSS feed to redirect permanently to the ATOM feed
      format.rss { redirect_to feed_path(:format => :atom), :status => :moved_permanently }
    end
  end

  def index
    @rids = @user.rblogs.select('blog_id').map{|x| x.blog_id}
    @blogs = @user.blogs.includes([:tags, :category]).where(:is_draft => false).page(params[:page]).order("created_at DESC")
    @categories = @user.categories.order('created_at')
    respond_to do |format|
      format.html      
    end
  end

  def show
    @blog = Blog.find(params[:id])
    if @blog.is_draft && @user.id != session[:id]
      redirect_to site @user
    else
      if @blog.user == @user
        add_view_count
        @categories = @user.categories.order('created_at')

        @blog_pre = @user.blogs.where(["category_id = ? AND created_at > ? AND is_draft = false", @blog.category_id, @blog.created_at]).order('created_at').first
        @blog_next = @user.blogs.where(["category_id = ? AND created_at < ? AND is_draft = false", @blog.category_id, @blog.created_at]).order('created_at DESC').first

        @all_comments = @blog.blogcomments.order('likecount DESC, created_at')
        @comments_uids = @all_comments.collect{|c| c.user_id}

        cate_blogs_ids = @user.blogs.where(:is_draft => false).where(["category_id = ?", @blog.category_id]).select('id')
        #TODO limit 4 make @all_cate_rblogs became a bug because view @blog.title may not shown as jian!
        @all_cate_rblogs = @user.r_blogs.where(:id => cate_blogs_ids).order('created_at DESC').limit(4)
        @cate_rblogs = @all_cate_rblogs - [@blog_pre, @blog_next, @blog]
        not_in_blogs_ids = @cate_rblogs.collect{|c| c.id} << @blog.id
        not_in_blogs_ids = not_in_blogs_ids << @blog_pre.id unless @blog_pre.nil?
        not_in_blogs_ids = not_in_blogs_ids << @blog_next.id unless @blog_next.nil?
        if @cate_rblogs.size < 4
          @cate_blogs = @user.blogs.where(["category_id = ? AND is_draft = false AND id not in (?)", @blog.category_id, not_in_blogs_ids]).order('created_at DESC').limit(4 - @cate_rblogs.size)
        end
        
        if @m
          render mr, :layout => 'm/portal'
        else
          render :layout => 'blog'
        end
      else
        r404
      end
    end
  end

  def new
    if session[:id] == @user.id
      @blog = Blog.new
      if @m
        render mr, :layout => 'm/portal'
      else
        render :layout => 'new'
      end
    else
      r404
    end
  end

  def edit
    @blog = Blog.find(params[:id])
    @tags = @blog.tags.map { |t| t.name }.join(" ")
    authorize @blog
    if @m
      render mr, :layout => 'm/portal'
    else
      render :layout => 'new'
    end
  end

  def create
    @blog = Blog.create(params[:blog])
    @blog.user_id = session[:id]
    @blog.replied_at = Time.now
    @blog.is_draft = true if params[:save_as_draft]
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
          flash[:error] = t('taken', :w => @category.name)
        end
        _render :new
      end
    end
  end

  def create_proc
    build_tags @blog
    if @blog.save
      user = @blog.user
      user.update_attribute('blogs_count', user.blogs_count + 1)
      if @blog.is_draft
        flash[:notice2] = t'blog_drafted'
      else
        flash[:notice2] = t'blog_posted'
      end
      #      expire_action :action => :index
      ping_search_engine(@blog)
      send_weibo
      send_qq
      redirect_to blog_path(@blog)
    else
      _render :new
    end
  end

  def update
    @blog = Blog.find(params[:id])
    @blog.is_draft = params[:save_as_draft] ? true : false
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
      tags_a.uniq.each do |tag|
        _tag = item.tags.build
        _tag.name = tag
      end
    end
  end

  def destroy
    @blog = Blog.find(params[:id])
    user = @blog.user
    #    expire_fragment('columns_articles') if @blog.columns.size > 0
    @blog.destroy
    #TODO NEED REFACTOR TO model user
    user.update_attribute('blogs_count', user.blogs_count - 1)
    flash[:notice] = t'delete_succ'
    if @m
      redirect_to notice_path
    else
      redirect_to blogs_path
    end
  end

  def click_show_blog
    @blog = Blog.find(params[:id])
    add_view_count
    @blog.content = summary_style(@blog, 4000)
    render :json => @blog.as_json()
  end

  #  def archives
  #    #ISSUE to_char maybe only work in postgresql
  #    @items = @user.blogs.where(:is_draft => false).select("to_char(created_at, 'YYYYMM') as t_date, count(id) as t_count").group("to_char(created_at, 'YYYYMM')").order('t_date DESC')
  #  end

  #  def month
  #    @blogs = @user.blogs.includes([:tags, :category]).where("to_char(created_at, 'YYYYMM') = ? and is_draft = false", params[:month]).page(params[:page])
  #    archives
  #  end

  def lovezhangtingting
    params[:id] = 2
    show
    render :show
  end

  def assign_columns
    @blog = Blog.find(params[:id])
    @columns = @blog.columns
    @all_columns = Column.order("created_at")
    render :layout => 'help'
  end

  def do_assign_columns
    blog = Blog.find(params[:id])
#    columns = blog.columns.where(:user_id => session[:id])
    column_ids = blog.columns.where(:user_id => session[:id]).select('id').map{|x| x.id}
    column_ids.each do |id|
      expire_fragment("portal_column_#{id}")
    end
    BlogsColumns.delete_all ["blog_id = ? AND column_id in (?)", blog.id, column_ids]
    unless params[:column].nil?
      params[:column].each do |k, v|
        blog.columns << Column.find(k)
        expire_fragment("portal_column_#{k}")
      end
    end
    expire_fragment("columns_articles_#{session[:id]}")
    redirect_to column_blogs_path, :notice => t('succ', :w => t('assign_columns'))
  end

  def assign_gcolumns
    @blog = Blog.find(params[:id])
    if @group.users.include? @blog.user
      @columns = @blog.gcolumns.where(:group_id => @group.id)
      @all_columns = @group.gcolumns.order("created_at")
      render :layout => 'help'
    else
      r404
    end
  end

  def do_assign_gcolumns
    blog = Blog.find(params[:id])
    gcolumn_ids = blog.gcolumns.where(:group_id => @group.id).select('id').map{|x| x.id}
    BlogsGcolumns.delete_all ["blog_id = ? AND gcolumn_id in (?)", blog.id, gcolumn_ids]
    unless params[:column].nil?
      params[:column].each do |k, v|
        #        blog.gcolumns << Gcolumn.find(k) this method no created_at.
        BlogsGcolumns.create(:blog => blog, :gcolumn => Gcolumn.find(k), :created_at => Time.now)
      end
    end
    redirect_to assign_gcolumns_blog_path(blog), :notice => t('succ', :w => t('assign_columns'))
  end

  def latest
    render :layout => 'portal'
  end

  def hotest
    render :layout => 'portal'
  end

  private
  def send_weibo
    #TODO  UPDATE FROM IS_DRAFT TO FALSE HAVN'T DO SEND.
    if weibo_active? and @blog.is_draft==false and Rails.env.production? and params[:sync_weibo] != "false"
      begin
        str = "#{@blog.title} - "
        data = "#{str}#{text_it_pure(@blog.content)[0..130-str.size]}#{site(@user) + blog_path(@blog)}"
        weibo_auth.statuses.update(data)
        #        Weibo::Base.new(oauth).update(data)
      rescue
        logger.warn("---Send_blog_to_weibo blog.id=#{@blog.id} failed.Data is #{data} #{session[:atoken]}")
      end
    end
  end

  def send_qq
    if qq_active? and @blog.is_draft==false and Rails.env.production? and params[:sync_qq] != "false"
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