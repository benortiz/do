class Taskpaper::Task
  TASK_LINE = /^\s*- (\d{4}-\d\d-\d\d \d\d:\d\d) \| (.*)/

  attr_accessor :note
  attr_reader :project, :note

  def initialize(project:, description:, date:)
    @project = project
    @description = description
    @date = date
    @note = Taskpaper::Note.new(task: self)
  end

  def to_s
    "\t- #{formatted_date} | #{@description}\n#{@note.to_s}"
  end

  def formatted_date
    @date.strftime(Taskpaper.config.date_format)
  end

end
