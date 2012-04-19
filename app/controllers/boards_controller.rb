class BoardsController < ApplicationController
  layout 'help'

  def show
    @board = Board.find(params[:id])
    if @board.nil?
      render text: t('page_not_found'), status: 404
    else
      #TODO How to eager loading count?
      @posts = @board.posts.includes([:user, :postcomments]).page(params[:page]).order('replied_at DESC')
    end
  end

  def members
    @board = Board.find(params[:id])
    if @board.nil?
      render text: t('page_not_found'), status: 404
    else
      @fboards = Fboard.where("board_id = ?", params[:id]).includes(:user).order('created_at DESC')
    end
  end

  def follow
    _r = Fboard.find_by_user_id_and_board_id(session[:id], params[:id])
    if _r.nil?
      fboard = Fboard.new
      fboard.user_id = session[:id]
      fboard.board_id = params[:id]
      fboard.save
    else
      _r.destroy
    end
#    render json: rnote.as_json
    redirect_to :back
  end

  def create
    @board = Board.new(params[:board])
    if @board.save
      flash[:notice] = t'create_succ'
      
      fboard = Fboard.new
      fboard.user_id = session[:id]
      fboard.board_id = @board.id
      fboard.save
    else
      flash[:error] = t'taken', w: @board.name
    end
    redirect_to root_path
  end

end
