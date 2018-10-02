module Storage::Local
  module_function

  def wdid
    if File.file?(wdid_file)
      contents = IO.read(wdid_file)
      contents.force_encoding('utf-8') if contents.respond_to? :force_encoding
    end
  end

  def setup_wdid(contents)
    if !File.file?(wdid_file)
      write(contents)
    end
  end

  def write(contents)
    File.open(wdid_file, 'w+') do |f|
      f.write(contents)
    end
  end

  def wdid_file
    File.expand_path(Do.config.storage[:local][:wdid])
  end
end
