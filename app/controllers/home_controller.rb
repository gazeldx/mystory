require 'will_paginate/array'
class HomeController < ApplicationController

  include Sina
  def index
    if @m
#      require 'will_paginate/array'
      if @bbs_flag
        @boards = Board.order("created_at DESC")
        @posts = Post.includes(:board, :user, :postcomments).order("id desc").limit(15)
        unless session[:id].nil?
          @fboards = Fboard.where("user_id = ?", session[:id]).includes(:board).order('created_at')
        end
        render 'm/boards/index', layout: 'm/portal'
      elsif @user.nil?
        t = params[:t]
        if t.nil?
          blogs = Blog.where(:is_draft => false).includes(:user).order("created_at desc").limit(15)
          notes = Note.where(:is_draft => false).includes(:user).order("created_at desc").limit(15)
          photos = Photo.includes(:album).order('photos.id desc').limit(6)
          @all = (notes | blogs | photos).sort_by{|x| x.created_at}.reverse!.paginate(:page => params[:page], :per_page => 15)
        elsif t == 'note'
          @all = Note.where(:is_draft => false).includes(:user).order("id desc").limit(80).paginate(:page => params[:page], :per_page => 15)
        elsif t == 'blog'
          @all = Blog.where(:is_draft => false).includes(:user).order("id desc").limit(80).paginate(:page => params[:page], :per_page => 15)
        elsif t == 'photo'
          @all = Photo.includes(:album).limit(40).order('photos.id desc').paginate(:page => params[:page], :per_page => 10)
        end
        render mr, layout: 'm/portal'
      else
        t = params[:t]
        if t.nil?
          notes = @user.notes.where(:is_draft => false).limit(30).order('created_at desc')
          blogs = @user.blogs.where(:is_draft => false).limit(20).order('created_at desc')
          photos = Photo.where(album_id: @user.albums).includes(:album).limit(6).order('id desc')
          all_ = notes | blogs | photos
          @memoir = @user.memoir
          unless @memoir.nil?
            @memoir.created_at = @memoir.updated_at
            all_ << @memoir
          end
          @all = all_.sort_by{|x| x.created_at}.reverse!.paginate(:page => params[:page], :per_page => 20)
        elsif t == 'note'
          @all = @user.notes.where(:is_draft => false).limit(60).order('created_at desc').paginate(:page => params[:page], :per_page => 15)
        elsif t == 'blog'
          @all = @user.blogs.where(:is_draft => false).limit(60).order('created_at desc').paginate(:page => params[:page], :per_page => 15)
        elsif t == 'photo'
          @all = Photo.where(album_id: @user.albums).includes(:album).limit(20).order('id desc').paginate(:page => params[:page], :per_page => 15)
        elsif t == 'updated'
          notes = @user.notes.where("updated_at > created_at and is_draft = false").limit(30)
          blogs = @user.blogs.where("updated_at > created_at and is_draft = false").limit(30)
          all_ = notes | blogs
          @memoir = @user.memoir
          all_ << @memoir unless @memoir.nil?
          @all = all_.sort_by{|x| x.updated_at}.reverse!.paginate(:page => params[:page], :per_page => 15)
        elsif t == 'recommend'
          #TODO .where(:is_draft => false) not do,maybe in view proc it is best.
          rnotes = @user.rnotes.includes(:note => :user).limit(30)
          rblogs = @user.rblogs.includes(:blog => :user).limit(20)
          rphotos = @user.rphotos.includes(:photo => [:album => :user]).limit(5)
          @all = (rnotes | rblogs | rphotos).sort_by{|x| x.created_at}.reverse!.paginate(:page => params[:page], :per_page => 15)
        end
        render mn(:user), layout: 'm/portal'
      end
    elsif @group != nil
      #      user_ids = @group.users.select('users.id')
      user_ids = GroupsUsers.select('user_id').where(group_id: @group.id)
      album_ids = Album.select('albums.id').where(user_id: user_ids)
      @photos = Photo.where(album_id: album_ids).includes(:album).order('photos.id desc').limit(5)
      @board = @group.board

      t = params[:t]
#      require 'will_paginate/array'
      if t.nil?
        notes = Note.where(user_id: user_ids).where(:is_draft => false).includes(:user).limit(15).order('notes.id desc')
        blogs = Blog.where(user_id: user_ids).where(:is_draft => false).includes(:user).limit(10).order('blogs.id desc')
        album_ids = Album.where(user_id: user_ids)
        photos = Photo.where(album_id: album_ids).includes(:album => :user).limit(6).order('photos.id desc')
        all_ = notes | blogs | photos
        memoirs = Memoir.where(user_id: user_ids).includes(:user)
        unless memoirs.blank?
          memoirs.each do |memoir|
            memoir.created_at = memoir.updated_at
          end
          all_ = all_ | memoirs
        end
        @all = all_.sort_by{|x| x.created_at}.reverse!.paginate(:page => params[:page], :per_page => 15)
      elsif t == 'note'
        @all = Note.where(user_id: user_ids).where(:is_draft => false).includes(:user).limit(40).page(params[:page]).order('notes.id desc')
      elsif t == 'blog'
        @all = Blog.where(user_id: user_ids).where(:is_draft => false).includes(:user).limit(40).page(params[:page]).order('blogs.id desc')
      elsif t == 'photo'
        @all = Photo.where(album_id: album_ids).includes(:album => :user).limit(50).page(params[:page]).order('photos.id desc')
      elsif t == 'updated'
        notes = Note.where(user_id: user_ids).where("notes.updated_at > notes.created_at AND is_draft = false").includes(:user).limit(20).order('notes.updated_at desc')
        blogs = Blog.where(user_id: user_ids).where("blogs.updated_at > blogs.created_at AND is_draft = false").includes(:user).limit(20).order('blogs.updated_at desc')
        all_ = notes | blogs
        memoirs = Memoir.where(user_id: user_ids).includes(:user)
        unless memoirs.blank?
          all_ = all_ | memoirs
        end
        #TODO paginate BUG? NOT SHOW 30 per page
        @all = all_.sort_by{|x| x.updated_at}.reverse!.paginate(:page => params[:page], :per_page => 15)
      elsif t == 'memoir'
        memoirs = Memoir.where(user_id: user_ids).includes(:user)
        @all = memoirs.sort_by{|x| x.updated_at}.reverse!.paginate(:page => params[:page], :per_page => 50)
      end
      
      render 'groups/show', layout: 'group'
    elsif @group_flag
      @groups = Group.where("member_count >= #{MIN_COLLEGE_MEMBER}").order("member_count DESC")
      render 'groups/index', layout: 'help'
    else
      if @bbs_flag
        @boards = Board.order("created_at DESC")
        @posts = Post.includes(:board, :user, :postcomments).order("id desc").limit(40)
        unless session[:id].nil?
          @board = Board.new
          @fboards = Fboard.where("user_id = ?", session[:id]).includes(:board).order('created_at')
        end
        render 'boards/index', layout: 'help'
      elsif @user.nil?
        #        if ENV["RAILS_ENV"] == "production"
        #          @users = User.find([2, 135, 11, 26, 3, 70, 18, 48, 22, 147, 39, 28, 44, 75, 110, 101, 131, 145])
        #          admin_id = 2
        #        else
        #          @users = User.find([1, 2, 3, 13, 5, 6, 7, 8, 9, 12, 11])
        #          admin_id = 14
        #        end
        #TODO DIFFERENT COLOR
        #        admin = User.find(admin_id)
        #        @r_blogs = admin.r_blogs.includes(:category, :user).order('created_at DESC').limit(9)
        #        @notes_new = Note.includes(:notecate, :user).order("created_at desc").limit(28)
        #        @blogs_new = Blog.where("user_id NOT IN (?)", USER_HASH_OLD.map { |k,v| k }).includes(:category, :user).order("created_at desc").limit(50)
        #        #TODO includes postcomments need to delete
        #        @posts = Post.includes(:board, :user, :postcomments).order("id desc").limit(8)
        #        @personage_blogs = Blog.where("user_id IN (?)", USER_HASH.map { |k,v| k }).includes(:category, :user, :blogcomments).order("created_at desc").limit(10)
        #
        #        rphotos = Rphoto.includes(:photo => [:album => :user]).limit(8).order('id desc').uniq {|s| s.photo_id}
        #        new_photo_count = 8 - rphotos.size
        #        new_photo_count = 2 if new_photo_count < 2
        #        photos = Photo.includes(:album => :user).limit(new_photo_count).order('id desc')
        #        @all_photos = (photos | rphotos).sort_by{|x| x.created_at}.reverse!

        #@blogs_side = @columns.includes(:blogs => :user).order("comments_count desc")
        #        blogs_new = Blog.where(:is_draft => false).includes(:category, :user).order("created_at desc").limit(12)
        #        notes_new = Note.where(:is_draft => false).includes(:notecate, :user).order("created_at desc").limit(6)
        #        @all = (blogs_new | notes_new).sort_by{|x| x.created_at}.reverse!
        #.page(params[:page])
        
        render layout: 'portal'
      else
        #TODO MODULIZE TWO LINE NEXT.
        @rnids = @user.rnotes.select('note_id').map{|x| x.note_id}
        @rbids = @user.rblogs.select('blog_id').map{|x| x.blog_id}
        t = params[:t]
        if t.nil?
          notes = @user.notes.where(:is_draft => false).limit(20).order("created_at desc")
          blogs = @user.blogs.where(:is_draft => false).limit(15).order("created_at desc")
          photos = Photo.where(album_id: @user.albums).includes(:album).order("id desc").limit(8)
          all_ = notes | blogs | photos
          @memoir = @user.memoir
          unless @memoir.nil?
            @memoir.created_at = @memoir.updated_at
            all_ << @memoir
          end
          @all = all_.sort_by{|x| x.created_at}.reverse!
        elsif t == 'note'
          @all = @user.notes.where(:is_draft => false).limit(50).order('created_at desc')
        elsif t == 'blog'
          @all = @user.blogs.where(:is_draft => false).limit(40).order('created_at desc')
        elsif t == 'photo'
          @all = Photo.where(album_id: @user.albums).includes(:album).limit(40).order('id desc')
        elsif t == 'updated'
          notes = @user.notes.where(:is_draft => false).where("updated_at > created_at").limit(20).order('updated_at desc')
          blogs = @user.blogs.where(:is_draft => false).where("updated_at > created_at").limit(15).order('updated_at desc')
          all_ = notes | blogs
          @memoir = @user.memoir
          all_ << @memoir unless @memoir.nil?
          @all = all_.sort_by{|x| x.updated_at}.reverse!
        elsif t == 'recommend'
          rnotes = @user.rnotes.includes(:note => :user).limit(15).order('id desc')
          rblogs = @user.rblogs.includes(:blog => :user).limit(20).order('id desc')
          rphotos = @user.rphotos.includes(:photo => [:album => :user]).limit(8).order('id desc')
          @all = (rnotes | rblogs | rphotos).sort_by{|x| x.created_at}.reverse!
        end
        render :user
      end
    end
  end

  def logout
    session[:id], session[:name], session[:domain] = nil, nil, nil
    session[:atoken], session[:expires_at] = nil, nil
    session[:token], session[:openid] = nil, nil
    if @m
      redirect_to m(site_url + login_path)
    else
      redirect_to root_path
    end
  end

  def notice
    render layout: 'm/portal'
  end

  def portal_body_show_more
    blogs = Blog.where(["id < ? AND is_draft = false AND comments_count > 0", params[:id]]).includes(:user).order("replied_at DESC").limit(30)
    render json: portal_list_html(blogs.select{|x| x.content.size > 40}).as_json
  end

  private
  def portal_list_html list
    html = ''
    list.each do |item|
      html += portal_item_html item
    end
    html
  end

  def portal_item_html item
    user = item.user
    n = photos_count item.content
    if n > 0
      t_class = "twi twiHasPic"
    else
      t_class = "twi"
    end
      #.pics         id="prev_{item.id}_0"
    twiM = content_tag(:div, content_tag(:p, thumb_here(item), :class => 'pics'), :class => 'twiM') if n > 0

    p_avt = content_tag(:p, user_pic(user), :class => 'avt ')
    b_b = content_tag(:b, raw("#{content_tag(:b, (link_to user.name, site(user), target: '_blank'), :class => 'nm')}#{t'maohao'}#{s_link_to item}"), :class => 'b pd')
    twiT = content_tag(:div, raw("#{p_avt}#{b_b}"), :class => 'twiT')

    ugc_c = auto_emotion(text_it_pure(item.content)[0..98])
    ugc_c += "......#{s_link_name(t('whole_article'), item)}" if item.content.size > 98
    p_ugc = content_tag(:p, raw(ugc_c), :class => 'ugc')
    b_c = ''
    cc = item.comments_count
    b_c += content_tag(:span, (s_link_to_comments t('comments_2', w: cc), item)) if cc > 0
    b_c += "&nbsp;&nbsp;&nbsp;#{fresh_time item.created_at}"
    b_tm = content_tag(:b, raw(b_c), :class => 'tm mi')
    twiB = content_tag(:div, b_tm, :class => 'twiB')
    twiC = content_tag(:div, raw("#{p_ugc}#{twiB}"), :class => 'twiC')

    content_tag(:div, raw("#{twiM}#{twiT}#{twiC}"), :class => t_class, id: item.id)
  end
end

class Array
  def uniq_by(&blk)
    transforms = []
    self.select do |el|
      should_keep = !transforms.include?(t=blk[el])
      transforms << t
      should_keep
    end
  end
end
