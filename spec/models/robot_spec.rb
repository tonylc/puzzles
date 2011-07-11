require 'spec_helper'

describe Robot do
  it 'should process a list of commands' do
    r = Robot.new(["PLACE 0,0,NORTH","MOVE","REPORT"])
    r.process_commands
    r.send(:return_position).should == [0,1,:NORTH]

    r = Robot.new(["PLACE 0,0,NORTH","LEFT","REPORT"])
    r.process_commands
    r.send(:return_position).should == [0,0,:WEST]

    r = Robot.new(["PLACE 1,2,EAST", "MOVE", "MOVE", "LEFT", "MOVE", "REPORT"])
    r.process_commands
    r.send(:return_position).should == [3,3,:NORTH]
  end

  it 'should not fall off table' do
    r = Robot.new(["PLACE 0,0,NORTH",
                  "LEFT", #0,0,WEST
                  "MOVE", #0,0,WEST
                ])
    r.process_commands
    r.send(:return_position).should == [0,0,:WEST]

    r = Robot.new(["PLACE 0,0,WEST",
                  "LEFT", #0,0,SOUTH
                  "MOVE", #0,0,SOUTH
                  "LEFT", #0,0,EAST
                  "MOVE", #1,0,EAST
                  "MOVE", #2,0,EAST
                  "MOVE", #3,0,EAST
                  "MOVE", #4,0,EAST
                  "MOVE", #5,0,EAST
                ])
    r.process_commands
    r.send(:return_position).should == [5,0,:EAST]

    r = Robot.new(["PLACE 5,0,EAST",
                  "MOVE", #5,0,EAST
                  "LEFT", #5,0,NORTH
                  "MOVE", #5,1,NORTH
                  "MOVE", #5,2,NORTH
                  "MOVE", #5,3,NORTH
                  "MOVE", #5,4,NORTH
                  "MOVE", #5,5,NORTH
                  "MOVE", #5,5,NORTH
                  "LEFT", #5,5,WEST
                ])
    r.process_commands
    r.send(:return_position).should == [5,5,:WEST]

    r = Robot.new(["PLACE 5,5,WEST",
                  "MOVE", #4,5,WEST
                  "MOVE", #3,5,WEST
                  "MOVE", #2,5,WEST
                  "MOVE", #1,5,WEST
                  "MOVE", #0,5,WEST
                  "MOVE", #0,5,WEST
                ])
    r.process_commands
    r.send(:return_position).should == [0,5,:WEST]

    r = Robot.new(["PLACE 0,5,WEST",
                  "LEFT", #0,5,SOUTH
                  "MOVE", #0,4,SOUTH
                  "MOVE", #0,3,SOUTH
                  "MOVE", #0,2,SOUTH
                  "MOVE", #0,1,SOUTH
                  "MOVE", #0,0,SOUTH
                  "MOVE", #0,0,SOUTH
                  ])
    r.process_commands
    r.send(:return_position).should == [0,0,:SOUTH]
  end

  describe 'Commands' do
    it 'should process PLACE command' do
      c = Robot::PlaceCommand.new("0,1,NORTH")
      c.process(nil,nil,nil).should == [0,1,:NORTH]
      
      c = Robot::PlaceCommand.new("0,1,NORTH")
    end

    it 'should process MOVE command' do
      c = Robot::MoveCommand.new
      c.process(0,0,:NORTH).should == [0,1,:NORTH]
      c.process(0,0,:EAST).should == [1,0,:EAST]
      c.process(1,0,:WEST).should == [0,0,:WEST]
      c.process(5,5,:SOUTH).should == [5,4,:SOUTH]
      c.process(5,4,:SOUTH).should == [5,3,:SOUTH]
      # even for invalid positions
      c.process(5,5,:NORTH).should == [5,6,:NORTH]
    end

    it 'should process LEFT commands' do
      c = Robot::LeftCommand.new
      c.process(0,0,:NORTH).should == [0,0,:WEST]
      c.process(0,0,:WEST).should == [0,0,:SOUTH]
      c.process(0,0,:SOUTH).should == [0,0,:EAST]
      c.process(0,0,:EAST).should == [0,0,:NORTH]
    end

    it 'should process RIGHT commands' do
      c = Robot::RightCommand.new
      c.process(0,0,:NORTH).should == [0,0,:EAST]
      c.process(0,0,:EAST).should == [0,0,:SOUTH]
      c.process(0,0,:SOUTH).should == [0,0,:WEST]
      c.process(0,0,:WEST).should == [0,0,:NORTH]
    end

    it 'should process REPORT commands' do
      c = Robot::ReportCommand.new
      c.process(0,1,:NORTH).should == [0,1,:NORTH]
    end

    it 'should NOT process UNKNOWN commands' do
      c = Robot::UnknownCommand.new
      c.process(0,1,:NORTH).should == [0,1,:NORTH]
    end
  end
end
