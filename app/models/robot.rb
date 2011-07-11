class Robot
  attr_reader :x,:y,:f

  def initialize(command_string_array)
    @commands = initialize_commands(command_string_array)
    @robot_initialized = false
  end

  def process_commands
    @commands.each do |command|
      next unless command.is_a?(Robot::PlaceCommand) || @robot_initialized
      x,y,f = command.process(@x,@y,@f)
      if valid_position?(x,y)
        set_positions!(x,y,f)
        @robot_initialized = true
      end
    end
  end

  def set_positions!(x,y,f)
    @x = x
    @y = y
    @f = f
  end

  def valid_position?(x,y)
    return (x >= 0) && (y >= 0) && (x <= 5) && (y <= 5)
  end

  private

  def initialize_commands(command_string_array)
    command_string_array.map do |command_string|
      command_str, positions = command_string.split(" ")
      begin
        klass_str = "Robot::#{command_str.capitalize}Command"
        klass = klass_str.constantize
        command_class = klass_str == "Robot::PlaceCommand" ? klass.new(positions) : klass.new
      rescue Exception => e
        command_class = Robot::UnknownCommand.new
      end
      command_class
    end
  end

  # testing purposes
  def return_position
    [@x,@y,@f]
  end

  class Command
    attr_reader :x, :x, :f
    DIRECTIONS = [:NORTH, :WEST, :SOUTH, :EAST]

    def initialize
    end

    def process(x,y,f)
      [x,y,f]
    end
  end

  class PlaceCommand < Command
    def initialize(positions)
      x, y, f = positions.split(",")
      @x = x.to_i
      @y = y.to_i
      @f = f.to_sym
    end

    def process(x,y,f)
      [@x, @y, @f]
    end
  end

  class MoveCommand < Command
    def process(x,y,f)
      case f
        when :NORTH
          y += 1
        when :SOUTH
          y -= 1
        when :EAST
          x += 1
        when :WEST
          x -= 1
      end

      [x, y, f]
    end
  end

  class LeftCommand < Command
    def process(x,y,f)
      num = DIRECTIONS.find_index(f)
      num += 1
      num = 0 if num > 3
      [x,y,DIRECTIONS[num]]
    end
  end

  class RightCommand < Command
    def process(x,y,f)
      num = DIRECTIONS.find_index(f)
      num -= 1
      num = 3 if num < 0
      [x,y,DIRECTIONS[num]]
    end
  end

  class ReportCommand < Command
    def process(x,y,f)
      p "OUTPUT: #{x}, #{y}, #{f}"
      super(x,y,f)
    end
  end

  class UnknownCommand < Command
  end
end
