class LikeController < ApplicationController
  layout 'like'

  def index
    following = Follow.where(["follower_id = ?", @user.id])
    following_ids = following.collect{|f| f.followable_id}
    following_ids << @user.id
    t = params[:t]
    require 'will_paginate/array'
    if t.nil?
#      @assortments = @user.assortments
      notes = Note.where(user_id: following_ids).where(:is_draft => false).includes(:user).limit(15).order('id desc')
      blogs = Blog.where(user_id: following_ids).where(:is_draft => false).includes(:user).limit(10).order('id desc')
      album_ids = Album.where(user_id: following_ids)
      photos = Photo.where(:album_id => album_ids).includes(:album => :user).limit(6).order('photos.id desc')
      #TODO why so many rnotes query sql?
      rnotes = Rnote.where(user_id: following_ids).includes(:note => :user).limit(8).order('id desc')
      rblogs = Rblog.where(user_id: following_ids).includes(:blog => :user).limit(8).order('id desc')      
      rphotos = Rphoto.where(user_id: following_ids).includes(:photo => [:album => :user]).limit(6).order('id desc')
      all_ = notes | blogs | photos | rnotes | rblogs | rphotos
      memoirs = Memoir.where(user_id: following_ids).includes(:user)
      unless memoirs.blank?
        memoirs.each do |memoir|
          memoir.created_at = memoir.updated_at
        end
        all_ = all_ | memoirs
      end
      @all = all_.sort_by{|x| x.created_at}.reverse!.paginate(:page => params[:page], :per_page => 15)
    elsif t == 'note'
      @all = Note.where(user_id: following_ids).where(:is_draft => false).includes(:user).limit(40).page(params[:page]).order('id desc')
    elsif t == 'blog'
      @all = Blog.where(user_id: following_ids).where(:is_draft => false).includes(:user).limit(40).page(params[:page]).order('id desc')
    elsif t == 'photo'
      album_ids = Album.where(user_id: following_ids)
      @all = Photo.where(:album_id => album_ids).includes(:album => :user).limit(50).page(params[:page]).order('photos.id desc')
    elsif t == 'updated'
      notes = Note.where(user_id: following_ids).where("updated_at > created_at AND is_draft = false").includes(:user).limit(20).order('updated_at desc')
      blogs = Blog.where(user_id: following_ids).where("updated_at > created_at AND is_draft = false").includes(:user).limit(20).order('updated_at desc')
      all_ = notes | blogs
      memoirs = Memoir.where(user_id: following_ids).includes(:user)
      unless memoirs.blank?
        all_ = all_ | memoirs
      end
      #TODO paginate BUG? NOT SHOW 30 per page
      @all = all_.sort_by{|x| x.updated_at}.reverse!.paginate(:page => params[:page], :per_page => 15)
    elsif t == 'recommend'
      rnotes = Rnote.where(user_id: following_ids).includes(:note => :user).limit(20).order('id desc')
      rblogs = Rblog.where(user_id: following_ids).includes(:blog => :user).limit(10).order('id desc')
      rphotos = Rphoto.where(user_id: following_ids).includes(:photo => [:album => :user]).limit(6).order('id desc')
      @all = (rnotes | rblogs | rphotos).sort_by{|x| x.created_at}.reverse!.paginate(:page => params[:page], :per_page => 15)
    end
    if @m
      render mr, :layout => 'm/portal'
    end
  end
end
