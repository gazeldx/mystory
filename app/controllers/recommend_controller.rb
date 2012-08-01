class RecommendController < ApplicationController
  
  def blog
    _r = Rblog.find_by_user_id_and_blog_id(session[:id], params[:id])
    blog = Blog.find(params[:id])
    if _r.nil?
      rblog = Rblog.new
      rblog.user_id = session[:id]      
      rblog.blog = blog
      rblog.save
      blog.update_attribute('recommend_count', blog.recommend_count + 1)
    else
      _r.destroy
      blog.update_attribute('recommend_count', blog.recommend_count - 1)
    end
    render json: rblog.as_json
  end

  def note
    _r = Rnote.find_by_user_id_and_note_id(session[:id], params[:id])
    note = Note.find(params[:id])
    if _r.nil?
      rnote = Rnote.new
      rnote.user_id = session[:id]
      rnote.note = note
      rnote.save
      note.update_attribute('recommend_count', note.recommend_count + 1)
    else
      _r.destroy
      note.update_attribute('recommend_count', note.recommend_count - 1)
    end
    render json: rnote.as_json
  end

  def photo
    _r = Rphoto.find_by_user_id_and_photo_id(session[:id], params[:id])
    if _r.nil?
      rphoto = Rphoto.new
      rphoto.user_id = session[:id]
      rphoto.photo_id = params[:id]
      rphoto.save
    else
      _r.destroy
    end
    render json: rphoto.as_json
  end

  def memoir
    _r = Rmemoir.find_by_user_id_and_memoir_id(session[:id], params[:id])
    if _r.nil?
      rmemoir = Rmemoir.new
      rmemoir.user_id = session[:id]
      rmemoir.memoir_id = params[:id]
      rmemoir.save
    else
      _r.destroy
    end
    render json: rmemoir.as_json
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

end
