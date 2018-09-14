class Local
  attr_accessor :config, :doing_file

  def initialize(config)
    self.config = config.config
  end

  def setup_with_config
    self.doing_file = File.expand_path(config['doing_file'])
    create(self.doing_file) unless File.exist?(self.doing_file)
    read
  end

  def setup_with_stdin(input_file:)
    self.doing_file = File.expand_path(input_file)
    if !File.size?(self.doing_file) && !File.file?(self.doing_file) && input_file.length < 256
      create(self.doing_file)
    end
    read
  end

  def read
    contents = IO.read(self.doing_file)
    contents = contents.force_encoding('utf-8') if contents.respond_to? :force_encoding
  end

  def write(contents)
    File.open(self.doing_file, 'w+') do |f|
      f.puts contents
    end
  end

  def create(filename)
    unless File.size?(filename)
      File.open(filename,'w+') do |f|
        f.puts config.current_section + ":"
      end
    end
  end
end
