require './pieces'

class Board
  def initialize
    reset_pieces
  end
  
  def [](pos)
    x, y = pos
    @grid[y][x]
  end
  
  def []=(pos, value)
    x, y = pos
    @grid[y][x] = value
  end

  def pieces
    @grid.flatten.compact
  end
  
  def reset_pieces
    @grid = Array.new(8) { Array.new(8, nil) } 

    # All pieces, sans pawns
    [[0, :white], [7, :black]].each do |(y, color)|
      x = 0
      [Rook, Knight, Bishop, King, Queen, Bishop, Knight, Rook].each do |piece|
        self[[x, y]] = piece.new(self, [x, y], color)
        x += 1
      end
    end

    # Pawns
    8.times do |i|
     self[[i, 1]] = Pawn.new(self, [i, 1], :white)
     self[[i, 6]] = Pawn.new(self, [i, 6], :black)
    end
  end
  
  def render
    puts "  #{('a'..'h').to_a.join(" ")}"
      
    @grid.each_with_index do |row, y|
      print "#{y + 1} "
      row.each_with_index do |piece, x|
        space = "#"
        space = " " if (x % 2 == 0 && y % 2 == 0) || (x % 2 != 0 && y % 2 != 0)
        print "#{piece.nil? ? space : piece } "
      end
      print "\n"
    end
  end

  def do_move(player, move)
    to_pos = [move.to_x, move.to_y]
    from = self[[move.from_x, move.from_y]]

    raise "Cannot move an empty piece." if from.nil?

    from.move(player, to_pos)
  end
  
  def in_check?(player)
    king = pieces.select { |piece| piece.is_a?(King) && piece.color == player.color }.first
    enemy_pieces = pieces.select { |piece| piece.color != player.color }
    enemy_pieces.any? { |piece| piece.moves.include?(king.pos) }
  end
end
