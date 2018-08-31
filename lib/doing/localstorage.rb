class Localstorage
  attr_reader :config

  def initialize(config)
    self.config = config.config
  end

  def setup_with_config
    doing_file = File.expand_path(config['doing_file'])
    create(doing_file) unless File.exist?(doing_file)
    read(doing_file)
  end

  def setup_with_stdin(input_file:)
    doing_file = File.expand_path(input_file)
    if !File.size?(doing_file) && !File.file?(doing_file) && input_file.length < 256
      create(doing_file)
    end
    read(doing_file)
  end

  def read(filepath)
    doing_file = IO.read(filepath)
    doing_file = doing_file.force_encoding('utf-8') if doing_file.respond_to? :force_encoding
  end

  def create(filename)
    unless File.size?(filename)
      File.open(filename,'w+') do |f|
        f.puts config.current_section + ":"
      end
    end
  end


end
