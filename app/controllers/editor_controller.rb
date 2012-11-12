class EditorController < ApplicationController
#  layout 'memoir'
#  include Recommend
  
  def index
    render :layout => 'portal'
  end

#  def blog
#    _r = Rblog.find_by_user_id_and_blog_id(session[:id], params[:id])
#    blog = Blog.find(params[:id])
#    if _r.nil?
#      save_rblog(blog, nil)
#    else
#      _r.destroy
#      Blog.update_all("recommend_count = #{blog.recommend_count - 1}", "id = #{blog.id}")
#    end
#    if blog.user.id == session[:id]
#      expire_fragment("side_user_rblogs_#{session[:id]}")
##      expire_fragment("side_blog_rblogs_#{session[:id]}")
#    end
#    render json: blog.reload.as_json
#  end
#
#  def note
#    _r = Rnote.find_by_user_id_and_note_id(session[:id], params[:id])
#    note = Note.find(params[:id])
#    if _r.nil?
#      save_rnote(note, nil)
#    else
#      _r.destroy
#      Note.update_all("recommend_count = #{note.recommend_count - 1}", "id = #{note.id}")
#    end
##    if note.user.id == session[:id]
##      expire_fragment("side_note_rnotes_#{session[:id]}")
##    end
#    render json: note.reload.as_json
#  end

end
