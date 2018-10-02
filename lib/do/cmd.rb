class Do::Cmd
  attr_reader :storage

  def initialize
    setup_wdid
  end

  private

  def setup_wdid
    raise if Do.config.storage.keys.length > 1

    case Do.config.storage.keys.first
    when :local
      @storage = Storage::Local.setup_wdid(default_project.title)
    end
  end

  def default_project
    Taskpaper::Project.new(name: Do.config.default_project)
  end
end
