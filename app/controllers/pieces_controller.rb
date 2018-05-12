class PiecesController < ApplicationController

  def index
    @pieces = Piece.all
  end

  def show
    @piece = Piece.find(params[:id])
  end

  def new  
    @piece = Piece.new
  end

  def create
    @piece = Piece.new(piece_params)
    if @piece.save then
      redirect_to pieces_url
    else
      render 'new'
    end
  end

  def edit
    @piece = Piece.find(params[:id])
  end

  def update
    @piece = Piece.find(params[:id])
    if @piece.update(piece_params)
      redirect_to @piece
    else
      render 'edit'
    end
  end
  
  private 
    def piece_params
      params.require(:piece).permit(:title, :artist, :date, :purchase_price, :picture, :print_number)
    end

end
