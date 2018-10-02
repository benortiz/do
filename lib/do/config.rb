require 'ostruct'
require 'deep_merge'

class Config
  FILE_NAME = '.dorc'
  # Config values come from three locations, in order of most to least
  # precedence
  # 1. local_config   `pwd`/.dorc
  # 2. global_config  ~/.dorc
  # 3. Defaults       {}
  def initialize
    @combined_config = defaults.deep_merge(global_config).deep_merge(local_config)
  end

  def attributes
    OpenStruct.new(@combined_config)
  end

  private

  def defaults
    {
      storage: {
        local: {
          wdid: '~/wdid.md'
        }
      },
      default_project: 'Currently',
      date_format: '%Y-%m-%d %H:%M'
    }
  end

  def global_config
    global_config_file = File.expand_path(File.join('~', FILE_NAME))
    if File.file?(global_config_file)
      YAML.load_file(global_config_file)
    else
      File.open(global_config_file, 'w') do |file|
        YAML.dump(defaults, file)
      end
    end
  end

  def local_config
    local_config_file = File.expand_path(File.join(Dir.pwd, FILE_NAME))
    if File.file?(local_config_file)
      YAML.load_file(local_config_file)
    end
  end
end
