class Taskpaper::Project
  PROJECT_LINE = /^(\S[\S ]+):\s*(@\S+\s*)*$/

  attr_accessor :tasks
  attr_reader :name

  def initialize(name:)
    @name = name
    @tasks = []
  end

  def to_s
    output = "#{title}\n"
    @tasks.each do |task|
      output += task.to_s
    end
    output
  end

  def title
    "#{@name}:"
  end

  def add_task(task)
    @tasks << task
  end
end
