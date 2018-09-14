class Taskpaper::Project
  PROJECT_LINE = /^(\S[\S ]+):\s*(@\S+\s*)*$/

  attr_accessor :tasks

  def initialize(name:)
    @name = name
    @tasks = []
  end

  def to_s
    output = "#{@name}:\n"
    @tasks.each do |task|
      output += task.to_s
    end
    output
  end

  def add_task(task)
    @tasks << task
  end
end
