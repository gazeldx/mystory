class ArchivesController < ApplicationController
  layout 'memoir'
  include Tags
  
  def index
    _ns = @user.notes.select("to_char(created_at, 'YYYYMM') as t_date, count(id) as t_count").group("to_char(created_at, 'YYYYMM')")
    _bs = @user.blogs.select("to_char(created_at, 'YYYYMM') as t_date, count(id) as t_count").group("to_char(created_at, 'YYYYMM')")
    _ps = Photo.where(album_id: @user.albums).select("to_char(created_at, 'YYYYMM') as t_date, count(id) as t_count").group("to_char(created_at, 'YYYYMM')")
    a = _ns + _bs + _ps
    h = Hash.new(0)
    a.each do |x|
      h[x.t_date] += x.t_count.to_i
    end
    @items = h.sort_by{|k, v| k}.reverse!   
    tagsIndex
  end

  def month
    case params[:t]
    when 'note'
      @all = @user.notes.where("to_char(created_at, 'YYYYMM') = ?", params[:month]).order('created_at desc')
    when 'blog'
      @all = @user.blogs.where("to_char(created_at, 'YYYYMM') = ?", params[:month]).order('created_at desc')
    when 'photo'
      @all = Photo.where(album_id: @user.albums).where("to_char(created_at, 'YYYYMM') = ?", params[:month]).includes(:album).order('id desc')
    when 'recommend'
      rnotes = @user.rnotes.where("to_char(created_at, 'YYYYMM') = ?", params[:month]).includes(:note => :user)
      rblogs = @user.rblogs.where("to_char(created_at, 'YYYYMM') = ?", params[:month]).includes(:blog => :user)
      rphotos = @user.rphotos.where("to_char(created_at, 'YYYYMM') = ?", params[:month]).includes(:photo => [:album => :user])
      @all = (rnotes | rblogs | rphotos).sort_by{|x| x.created_at}.reverse!
    else
      notes = @user.notes.where("to_char(created_at, 'YYYYMM') = ?", params[:month])
      blogs = @user.blogs.where("to_char(created_at, 'YYYYMM') = ?", params[:month])
      photos = Photo.where(album_id: @user.albums).where("to_char(created_at, 'YYYYMM') = ?", params[:month]).includes(:album)
      @all = (notes | blogs | photos).sort_by{|x| x.created_at}.reverse!
    end
    
    index
  end

end
