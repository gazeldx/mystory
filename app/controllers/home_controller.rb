class HomeController < ApplicationController

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
          blogs = Blog.includes(:user).order("id desc").limit(30)
          notes = Note.includes(:user).order("id desc").limit(20)
          photos = Photo.includes(:album).limit(10).order('photos.id desc')
          @all = (notes | blogs | photos).sort_by{|x| x.created_at}.reverse!.paginate(:page => params[:page], :per_page => 10)
        elsif t == 'note'
          @all = Note.includes(:user).order("id desc").limit(60).paginate(:page => params[:page], :per_page => 20)
        elsif t == 'blog'
          @all = Blog.includes(:user).order("id desc").limit(60).paginate(:page => params[:page], :per_page => 20)
        elsif t == 'photo'
          @all = Photo.includes(:album).limit(45).order('photos.id desc').paginate(:page => params[:page], :per_page => 15)
        end
        render mr, layout: 'm/portal'
      else
        t = params[:t]
        if t.nil?
          notes = @user.notes.limit(30)
          blogs = @user.blogs.limit(10)
          photos = Photo.where(album_id: @user.albums).includes(:album).limit(6).order('id desc')
          all_ = notes | blogs | photos
          memoir = @user.memoir
          unless memoir.nil?
            memoir.created_at = memoir.updated_at
            all_ << memoir
          end
          @all = all_.sort_by{|x| x.created_at}.reverse!.paginate(:page => params[:page], :per_page => 20)
        elsif t == 'note'
          @all = @user.notes.limit(50).order('created_at desc').paginate(:page => params[:page], :per_page => 20)
        elsif t == 'blog'
          @all = @user.blogs.limit(40).order('created_at desc').paginate(:page => params[:page], :per_page => 20)
        elsif t == 'photo'
          @all = Photo.where(album_id: @user.albums).includes(:album).limit(20).order('id desc').paginate(:page => params[:page], :per_page => 20)
        elsif t == 'updated'
          notes = @user.notes.where("updated_at > created_at").limit(30)
          blogs = @user.blogs.where("updated_at > created_at").limit(30)
          all_ = notes | blogs
          memoir = @user.memoir
          all_ << memoir unless memoir.nil?
          @all = all_.sort_by{|x| x.updated_at}.reverse!.paginate(:page => params[:page], :per_page => 20)
        elsif t == 'recommend'
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
        @posts = Post.includes([:board, :user, :postcomments]).order("id desc").limit(40)
        unless session[:id].nil?
          @board = Board.new
          @fboards = Fboard.where("user_id = ?", session[:id]).includes(:board).order('created_at')
        end
        render 'boards/index', layout: 'help'
      elsif @user.nil?
        @notes_new = Note.includes(:user).order("id desc").limit(10)
        @blogs_new = Blog.includes(:user).order("id desc").limit(16)
        @posts = Post.includes(:user).order("id desc").limit(8)
        if DOMAIN_NAME=="mystory.cc"
          @users = User.find([2, 11, 26, 70, 18, 48, 22, 39, 28, 44, 75, 110, 101])
        else
          @users = User.find([1, 2, 3, 13, 5, 6, 7, 8, 9, 12, 11])
        end
        rphotos = Rphoto.includes(:photo => [:album => :user]).limit(8).order('id desc').uniq {|s| s.photo_id}
        new_photo_count = 8 - rphotos.size
        new_photo_count = 2 if new_photo_count < 2
        photos = Photo.includes(:album => :user).limit(new_photo_count).order('id desc')
        @all_photos = (photos | rphotos).sort_by{|x| x.created_at}.reverse!

        render layout: 'portal'
      else
        @photos = Photo.where(album_id: @user.albums).limit(5).order('id desc')

        t = params[:t]
        if t.nil?
          notes = @user.notes.limit(30)
          blogs = @user.blogs.limit(10)
          photos = Photo.where(album_id: @user.albums).includes(:album).limit(15)
          all_ = notes | blogs | photos
          memoir = @user.memoir
          unless memoir.nil?
            memoir.created_at = memoir.updated_at
            all_ << memoir
          end
          @all = all_.sort_by{|x| x.created_at}.reverse!
        elsif t == 'note'
          @all = @user.notes.limit(50).order('created_at desc')
        elsif t == 'blog'
          @all = @user.blogs.limit(40).order('created_at desc')
        elsif t == 'photo'
          @all = Photo.where(album_id: @user.albums).includes(:album).limit(50).order('id desc')
        elsif t == 'updated'
          notes = @user.notes.where("updated_at > created_at").limit(30)
          blogs = @user.blogs.where("updated_at > created_at").limit(30)
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

        ids = @user.blogs.select('id')
        @rblogs = @user.r_blogs.where(id: ids).limit(5)

        render :user
      end
    end
  end

  def logout
    session[:id] = nil
    session[:name] = nil
    session[:domain] = nil
    if @m      
      redirect_to m(SITE_URL + login_path)
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
