class LettersController < ApplicationController
  layout 'letter'

  before_filter :url_authorize, :only => [:index, :sent, :received, :show]
  before_filter :letters_count, :only => [:index, :sent, :received, :new]

  def new
    @letter = Letter.new
    @letter.user_id = session[:id]
    @recipient = User.find_by_domain(params[:domain])
    @letter.recipient_id = @recipient.id
    @letters = Letter.where("(user_id = ? and recipient_id = ?) or (recipient_id = ? and user_id = ?)", session[:id], @recipient.id, session[:id], @recipient.id).order("created_at DESC")
    puts @letters.size
  end

  def create
    @letter = Letter.create(params[:letter])
    @letter.user_id = session[:id]
    if @letter.save
      flash[:notice] = t'letter_sent'
      redirect_to letters_path
    else
      render :new
    end
  end

  def letters_count
    @sent_count = Letter.where("user_id = ?", session[:id]).count
    @received_count = Letter.where("recipient_id = ?", session[:id]).count
  end

  def index
    # like weibo.com is best
    user = User.find(session[:id])
    sent = user.letters.order("created_at DESC").includes(:recipient).limit(50)
    received = Letter.where("recipient_id = ?", session[:id]).includes(:user).order("created_at DESC").limit(50)
    @letters = (sent | received).sort_by{|x| x.created_at}.reverse!
  end

  def sent
    user = User.find(session[:id])
    @letters = user.letters.page(params[:page]).includes(:recipient).order("created_at DESC")
  end

  def received
    @letters = Letter.where("recipient_id = ?", session[:id]).page(params[:page]).includes(:user).order("created_at DESC")
  end

  def show
    @letter = Letter.find(params[:id])
    if @letter.user == @user
      @categories = @user.categories.order('created_at')
      @letter_pre = @user.letters.where(["category_id = ? AND created_at > ?", @letter.category_id, @letter.created_at]).order('created_at').first
      @letter_next = @user.letters.where(["category_id = ? AND created_at < ?", @letter.category_id, @letter.created_at]).order('created_at DESC').first
      comments = @letter.lettercomments
      @all_comments = (comments | @letter.rletters.select{|x| !(x.body.nil? or x.body.size == 0)}).sort_by{|x| x.created_at}
      @comments_uids = comments.collect{|c| c.user_id}
      ids = @user.letters.select('id')
      @rletters = @user.r_letters.where(id: ids).limit(5)
      render layout: 'memoir_share'
    else
      r404
    end
  end

  

  def edit
    @letter = Letter.find(params[:id])
    @tags = @letter.tags.map { |t| t.name }.join(" ")
    authorize @letter
  end

  

  

  def update
    @letter = Letter.find(params[:id])
    if @letter.update_attributes(params[:letter])
      @letter.tags.destroy_all
      build_tags @letter
      @letter.update_attributes(params[:letter])
      flash[:notice2] = t'update_succ'
      redirect_to letter_path
    else
      render :edit
    end
  end

  def build_tags(item)
    unless params[:tags].to_s == ''
      tags_a = params[:tags].split ' '
      tags_a.uniq.reverse.each do |tag|
        _tag = item.tags.build
        _tag.name = tag
      end
    end
  end

  def destroy
    @letter = Letter.find(params[:id])
    @letter.destroy
    redirect_to letters_path, notice: t('delete_succ')
  end

  def click_show_letter
    @letter = Letter.find(params[:id])
    @letter.content = summary_comment_style(@letter, 4000)
    render json: @letter.as_json()
  end

  def lovezhangtingting
    params[:id] = 2
    show
    render :show
  end
end