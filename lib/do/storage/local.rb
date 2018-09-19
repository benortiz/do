module Storage::Local
  module_function

  def wdid
    if File.file?(Do.config.wdid)
      read(File.expand_path(Do.config.wdid))
    end
  end

  def read(file)
    contents = IO.read(file)
    contents.force_encoding('utf-8') if contents.respond_to? :force_encoding
  end

  def write(file, contents)
    File.open(file, 'w+') do |f|
      f.puts contents
    end
  end
end
