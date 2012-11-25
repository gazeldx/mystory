class RecommendController < ApplicationController
  include Recommend
  def blog
    _r = Rblog.find_by_user_id_and_blog_id(session[:id], params[:id])
    blog = Blog.find(params[:id])
    if _r.nil?
      save_rblog(blog, nil)
    else
      _r.destroy
      Blog.update_all("recommend_count = #{blog.recommend_count - 1}", "id = #{blog.id}")
    end
    if blog.user.id == session[:id]
      expire_fragment("side_user_rblogs_#{session[:id]}")
#      expire_fragment("side_blog_rblogs_#{session[:id]}")
    end
    render json: blog.reload.as_json
  end

  def note
    _r = Rnote.find_by_user_id_and_note_id(session[:id], params[:id])
    note = Note.find(params[:id])
    if _r.nil?
      save_rnote(note, nil)
    else
      _r.destroy
      Note.update_all("recommend_count = #{note.recommend_count - 1}", "id = #{note.id}")
    end
#    if note.user.id == session[:id]
#      expire_fragment("side_note_rnotes_#{session[:id]}")
#    end
    render json: note.reload.as_json
  end

  def photo
    _r = Rphoto.find_by_user_id_and_photo_id(session[:id], params[:id])
    photo = Photo.find(params[:id])
    if _r.nil?
      save_rphoto(photo, nil)
    else
      _r.destroy
      Photo.update_all({:recommend_count => photo.recommend_count - 1}, {:id => photo.id})
    end
    render json: photo.reload.as_json
  end

  def memoir
    _r = Rmemoir.find_by_user_id_and_memoir_id(session[:id], params[:id])
    memoir = Memoir.find(params[:id])
    if _r.nil?
      save_rmemoir(memoir, nil)
    else
      _r.destroy
      Memoir.update_all("recommend_count = #{memoir.recommend_count - 1}", "id = #{memoir.id}")
    end
    render json: memoir.reload.as_json
  end

  def modify_blog
    @rblog = Rblog.find(params[:id])
    head :ok if @rblog.update_attributes(params[:ri])
  end
  
  def modify_note
    @rnote = Rnote.find(params[:id])
    head :ok if @rnote.update_attributes(params[:ri])
  end

  def modify_photo
    @rphoto = Rphoto.find(params[:id])
    head :ok if @rphoto.update_attributes(params[:ri])
  end

  def modify_memoir
    @rmemoir = Rmemoir.find(params[:id])
    head :ok if @rmemoir.update_attributes(params[:ri])
  end

  def query_recommend_users
    case params[:stype]
    when 'blog'
      article = Blog.find(params[:id])
      rs = article.rblogs
    when 'note'
      article = Note.find(params[:id])
      rs = article.rnotes
    when 'photo'
      article = Photo.find(params[:id])
      rs = article.rphotos
    when 'memoir'
      article = Memoir.find(params[:id])
      rs = article.rmemoirs
    end
    r_recommends = rs.includes(:user)
    text = t'been_recommended'
    r_recommends.each_with_index do |r, i|
      user = r.user
      text += "<a href='#{site(user)}' target='_blank'>#{user.name[0..4]}</a>"
      unless i == r_recommends.length - 1
        text += ",&nbsp;"
      end
    end
    render :text => text
  end

end
