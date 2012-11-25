class EbooksController < ApplicationController

  def txt
    blogs = @user.blogs.visible
    notes = @user.notes.visible
    all = (blogs | notes).sort_by{|x| x.created_at}.reverse!
    render :text => as_txt(all)
  end

  private
  def as_txt(articles)    
    txt = "#{t('ebook_profile', :name => @user.name, :site => site(@user), :city => @user.city, :jobs => @user.jobs, :birthday => @user.birthday, :school => @user.school, :maxin => @user.maxim, :memo => @user.memo, :blogs_count => @user.blogs_count, :notes_count => @user.notes_count, :photos_count => @user.photos_count, :followers_num => @user.followers_num, :following_num => @user.following_num)}\r\n"
    @user.hobbies.each_with_index do |hobby, i|
      txt << (t'_hobby_') if i==0
      txt << "#{hobby.name} "
    end
    @user.idols.each_with_index do |idol, i|
      txt << ("\r\n#{t'_idol_'}") if i==0
      txt << "#{idol.name} "
    end
    #TODO add enjoys here
    memoir = @user.memoir
    txt << "\r\n\r\n#{@user.name}#{t'_memoir'} - #{memoir.title} #{memoir.updated_at.strftime t('time_format')}#{t'update'}\r\n#{article_url(memoir)}\r\n#{text_it_ebook(memoir.content)}\r\n\r\n" unless memoir.nil?
    articles.each do |article|
      txt << "#{article_title(article)} #{article.created_at.strftime t('time_format')}\r\n#{article_url(article)}\r\n#{text_it_ebook(article.content)}\r\n\r\n"
    end
    txt
  end
end
