class Taskpaper::Outline
  attr_accessor :raw_content

  def initialize(raw_content:)
    self.raw_content = raw_content
  end

  # PONDER:
  #   - Just pass the line into the other classes and have them handle the
  #   parsing.
  #   - Is there another way besides nil + .compact?
  # Take a StringIO and turns it into an array of Taskpaper::Projects
  def to_structure
    project = Taskpaper::Project.new(name: "Uncategorized")
    task = nil

    raw_content.lines.map do |line|
      next if line.strip.empty?
      if line =~ Taskpaper::Project::PROJECT_LINE
        project_name = $1
        project = Taskpaper::Project.new(name: project_name)
      elsif line =~ Taskpaper::Task::TASK_LINE
        date = Time.parse($1)
        task_description = $2
        task = Taskpaper::Task.new(project: project,
                                   description: task_description,
                                   date: date)
        project.add_task(task)
        nil
      elsif line =~ Taskpaper::Note::NOTE_LINE
        note = $1
        task.note.add_line(note)
        nil
      end
    end.compact
  end

  # Turn the structured taskpaper into a string for writting to some storage
  def to_s
    to_structure.map(&:to_s).reduce(:+)
  end

  def add_project
  end

  def find_project
  end

  def projects
  end

  def add_task
  end

  def find_task
  end

  def tasks
  end
end
