class Do::Cmd
  attr_reader :storage, :paper, :results

  def initialize
    setup_wdid
    @results = []
    @paper = Taskpaper::Outline.new(raw_content: @storage.wdid)
  end

  def now(options, args)
    project = find_or_create_project(options[:p])

    if options[:e] || (args.length == 0 && STDIN.stat.size == 0)
      input = read_task_from_editor(args)
    elsif args.length > 0 || STDIN.stat.size > 0
      input = args.join(" ")
    else
      raise "You must provide content when creating a new entry"
    end

    create_task(project, input)
  end

  private

  def setup_wdid
    raise if Do.config.storage.keys.length > 1

    case Do.config.storage.keys.first
    when :local
      Storage::Local.setup_wdid(default_project.title)
      @storage = Storage::Local
    end
  end

  def fork_editor(input = "")
    tmpfile = Tempfile.new('do')

    File.open(tmpfile.path,'w+') do |f|
      f.puts input
    end

    pid = Process.fork { system("$EDITOR #{tmpfile.path}") }

    trap("INT") {
      Process.kill(9, pid) rescue Errno::ESRCH
      tmpfile.unlink
      tmpfile.close!
      exit 0
    }

    Process.wait(pid)

    begin
      if $?.exitstatus == 0
        input = IO.read(tmpfile.path)
      else
        raise "Cancelled"
      end
    ensure
      tmpfile.close
      tmpfile.unlink
    end

    input
  end

  def read_task_from_editor(args)
    raise "No EDITOR variable defined in environment" if ENV['EDITOR'].nil?
    input = fork_editor(args.join(" "))
    raise "No content" unless input
    input
  end

  def default_project
    Taskpaper::Project.new(name: Do.config.default_project)
  end

  def find_or_create_project(project_name)
    project_name = project_name.capitalize
    project = @paper.find_project(project_name)

    unless project
      print "Create a new section called #{project_name} (y/N)?"
      prompt = STDIN.gets
      if prompt =~ /^y/i
        project = Taskpaper::Project.new(name: project_name)
        @paper.add_project(project)
        @storage.write(@paper.to_s)
      end
    end

    project ||= Taskpaper::Project.new(name: project_name)
  end

  def extract_task_description_and_note_lines(input)
    lines = input.split("\n")
    task_description = lines[0]
    note_lines = lines[1..-1]

    [task_description, note_lines]
  end

  def create_task(project, input)
    date = Time.now
    task_description, note_lines = extract_task_description_and_note_lines(input)
    task = Taskpaper::Task.new(project: project, description: task_description, date: date)
    note_lines.each do |line|
      task.note.add_line(line)
    end
    project.add_task(task)
    @storage.write(@paper.to_s)
  end
end
