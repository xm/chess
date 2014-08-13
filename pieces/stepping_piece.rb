class SteppingPiece < Piece
  def moves
    moves = []
    
    move_dirs.each do |offset|
      dpos = [@pos[0] + offset[0], @pos[1] + offset[1]]
      moves << dpos if @board.legal_move?(self, dpos)
    end
    
    moves
  end
end