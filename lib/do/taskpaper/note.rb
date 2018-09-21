class Taskpaper::Note
  NOTE_LINE = /^\t\t([\w\s]+)/

  def initialize(task:, lines: [])
    @task = task
    @lines = lines
  end

  def to_s
    @lines.map { |line| "\t\t#{line}" }.join("\n")
  end

  def add_line(line)
    @lines << line.chomp.strip
  end

end
