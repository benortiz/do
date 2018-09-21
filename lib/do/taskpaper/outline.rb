class Taskpaper::Outline
  attr_accessor :projects

  def initialize(raw_content:)
    @raw_content = raw_content
  end

  def to_s
    projects.map(&:to_s).reduce(:+)
  end

  def find_project(name)
    projects.detect { |project| project.name == name }
  end

  def add_project(project)
    projects << project
  end

  def projects
    @projects ||= to_structure
  end

  def tasks
    projects.map(&:tasks).flatten
  end

  private

  # Take a StringIO and turns it into an array of Taskpaper::Projects
  def to_structure
    project = Taskpaper::Project.new(name: "Uncategorized")
    task = nil

    @raw_content.lines.map do |line|
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
end
