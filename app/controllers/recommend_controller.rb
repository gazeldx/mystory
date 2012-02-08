class RecommendController < ApplicationController
  
  def blog
    _r = Rblog.find_by_user_id_and_blog_id(session[:id], params[:id])
    puts _r
    if _r.nil?
      rblog = Rblog.new
      rblog.user_id = session[:id]
      rblog.blog_id = params[:id]
      rblog.save
    else
      _r.destroy
    end
    render json: rblog.as_json
  end

  def note
    _r = Rnote.find_by_user_id_and_note_id(session[:id], params[:id])
    if _r.nil?
      rnote = Rnote.new
      rnote.user_id = session[:id]
      rnote.note_id = params[:id]
      rnote.save
    else
      _r.destroy
    end
    render json: rnote.as_json
  end

  def modify_blog
    @rblog = Rblog.find(params[:id])
    puts "sddddddddddddddddddddddddddkk"
    puts @rblog.inspect
    head :ok if @rblog.update_attributes(params[:ri])
  end
  
  def modify_note
    @rnote = Rnote.find(params[:id])
    head :ok if @rnote.update_attributes(params[:ri])
  end

end
