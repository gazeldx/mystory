class HomeController < ApplicationController

  include Sina
  def index
    if @m
      require 'will_paginate/array'
      if @bbs_flag
        @boards = Board.order("created_at DESC")
        unless session[:id].nil?
          #@board = Board.new
          @fboards = Fboard.where("user_id = ?", session[:id]).includes(:board).order('created_at')
        end
        render 'm/boards/index', layout: 'm/portal'
      elsif @user.nil?
        t = params[:t]
        if t.nil?
          blogs = Blog.where(:is_draft => false).includes(:user).order("created_at desc").limit(30)
          notes = Note.where(:is_draft => false).includes(:user).order("created_at desc").limit(20)
          photos = Photo.includes(:album).limit(10).order('photos.id desc')
          @all = (notes | blogs | photos).sort_by{|x| x.created_at}.reverse!.paginate(:page => params[:page], :per_page => 10)
        elsif t == 'note'
          @all = Note.where(:is_draft => false).includes(:user).order("id desc").limit(60).paginate(:page => params[:page], :per_page => 20)
        elsif t == 'blog'
          @all = Blog.where(:is_draft => false).includes(:user).order("id desc").limit(60).paginate(:page => params[:page], :per_page => 20)
        elsif t == 'photo'
          @all = Photo.includes(:album).limit(45).order('photos.id desc').paginate(:page => params[:page], :per_page => 15)
        end
        render mr, layout: 'm/portal'
      else
        t = params[:t]
        if t.nil?
          notes = @user.notes.where(:is_draft => false).limit(30).order('created_at desc')
          blogs = @user.blogs.where(:is_draft => false).limit(20).order('created_at desc')
          photos = Photo.where(album_id: @user.albums).includes(:album).limit(6).order('id desc')
          all_ = notes | blogs | photos
          memoir = @user.memoir
          unless memoir.nil?
            memoir.created_at = memoir.updated_at
            all_ << memoir
          end
          @all = all_.sort_by{|x| x.created_at}.reverse!.paginate(:page => params[:page], :per_page => 20)
        elsif t == 'note'
          @all = @user.notes.where(:is_draft => false).limit(50).order('created_at desc').paginate(:page => params[:page], :per_page => 20)
        elsif t == 'blog'
          @all = @user.blogs.where(:is_draft => false).limit(40).order('created_at desc').paginate(:page => params[:page], :per_page => 20)
        elsif t == 'photo'
          @all = Photo.where(album_id: @user.albums).includes(:album).limit(20).order('id desc').paginate(:page => params[:page], :per_page => 20)
        elsif t == 'updated'
          notes = @user.notes.where("updated_at > created_at and is_draft = false").limit(30)
          blogs = @user.blogs.where("updated_at > created_at and is_draft = false").limit(30)
          all_ = notes | blogs
          memoir = @user.memoir
          all_ << memoir unless memoir.nil?
          @all = all_.sort_by{|x| x.updated_at}.reverse!.paginate(:page => params[:page], :per_page => 20)
        elsif t == 'recommend'
          #TODO .where(:is_draft => false) not do,maybe in view proc it is best.
          rnotes = @user.rnotes.includes(:note => :user).limit(30)
          rblogs = @user.rblogs.includes(:blog => :user).limit(15)
          rphotos = @user.rphotos.includes(:photo => [:album => :user]).limit(5)
          @all = (rnotes | rblogs | rphotos).sort_by{|x| x.created_at}.reverse!.paginate(:page => params[:page], :per_page => 20)
        end
        render mn(:user), layout: 'm/portal'
      end
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
        @columns = Column.order('created_at').limit(6)
        #@blogs_side = @columns.includes(:blogs => :user).order("comments_count desc")
#        blogs_new = Blog.where(:is_draft => false).includes(:category, :user).order("created_at desc").limit(12)
#        notes_new = Note.where(:is_draft => false).includes(:notecate, :user).order("created_at desc").limit(6)
#        @all = (blogs_new | notes_new).sort_by{|x| x.created_at}.reverse!
        @columns = Column.order("created_at").limit(6)
        @blogs = Blog.where('replied_at is not null and is_draft = false').page(params[:page]).order("replied_at DESC")
        notes = Note.where('replied_at is not null and is_draft = false').page(params[:page]).order("replied_at DESC")
        @all = (@blogs | notes).sort_by{|x| x.replied_at}.reverse!
        render layout: 'portal'
      else
        @photos = Photo.where(album_id: @user.albums).limit(5).order('id desc')
#        @user_timeline = user_timeline({count: 1, feature: 1})

        t = params[:t]
        if t.nil?
          notes = @user.notes.where(:is_draft => false).limit(30).order("created_at desc")
          blogs = @user.blogs.where(:is_draft => false).limit(20).order("created_at desc")
          photos = Photo.where(album_id: @user.albums).includes(:album).limit(15)
          all_ = notes | blogs | photos
          memoir = @user.memoir
          unless memoir.nil?
            memoir.created_at = memoir.updated_at
            all_ << memoir
          end
          @all = all_.sort_by{|x| x.created_at}.reverse!
        elsif t == 'note'
          @all = @user.notes.where(:is_draft => false).limit(50).order('created_at desc')
        elsif t == 'blog'
          @all = @user.blogs.where(:is_draft => false).limit(40).order('created_at desc')
        elsif t == 'photo'
          @all = Photo.where(album_id: @user.albums).includes(:album).limit(50).order('id desc')
        elsif t == 'updated'
          notes = @user.notes.where(:is_draft => false).where("updated_at > created_at").limit(30)
          blogs = @user.blogs.where(:is_draft => false).where("updated_at > created_at").limit(30)
          all_ = notes | blogs
          memoir = @user.memoir
          all_ << memoir unless memoir.nil?
          @all = all_.sort_by{|x| x.updated_at}.reverse!
        elsif t == 'recommend'
          rnotes = @user.rnotes.includes(:note => :user).limit(30)
          rblogs = @user.rblogs.includes(:blog => :user).limit(15)
          rphotos = @user.rphotos.includes(:photo => [:album => :user]).limit(10)
          @all = (rnotes | rblogs | rphotos).sort_by{|x| x.created_at}.reverse!
        end

        ids = @user.blogs.where(:is_draft => false).select('id')
        @rblogs = @user.r_blogs.where(id: ids).limit(7)

        render :user
      end
    end
  end

  def logout
    session[:id], session[:name], session[:domain] = nil, nil, nil
    session[:atoken], session[:asecret] = nil, nil
    if @m
      redirect_to m(site_url + login_path)
    else
      redirect_to root_path
    end
  end

  def notice
    render layout: 'm/portal'
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
