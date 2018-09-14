class Config
  attr_accessor :config,
                :current_section,
                :default_template,
                :default_date_format

  # Config values come from three locations, in order of least -> most
  # precedence
  # 1. Defaults
  # 2. ~/.doingrc
  # 3. current working directory .doingrc
  def initialize
  end

  def defaults
    @default_config_file = '.doingrc'
    @timers = {}

    @config = read_config
    user_config = @config.dup

    @config['autotag'] ||= {}
    @config['autotag']['whitelist'] ||= []
    @config['autotag']['synonyms'] ||= {}
    @config['doing_file'] ||= "~/what_was_i_doing.md"
    @config['current_section'] ||= 'Currently'
    @config['editor_app'] ||= nil
    @config['templates'] ||= {}
    @config['templates']['default'] ||= {
      'date_format' => '%Y-%m-%d %H:%M',
      'template' => '%date | %title%note',
      'wrap_width' => 0
    }
    @config['templates']['today'] ||= {
      'date_format' => '%_I:%M%P',
      'template' => '%date: %title %interval%note',
      'wrap_width' => 0
    }
    @config['templates']['last'] ||= {
      'date_format' => '%-I:%M%P on %a',
      'template' => '%title (at %date)%odnote',
      'wrap_width' => 88
    }
    @config['templates']['recent'] ||= {
      'date_format' => '%_I:%M%P',
      'template' => '%shortdate: %title',
      'wrap_width' => 88
    }
    @config['views'] ||= {
      'done' => {
        'date_format' => '%_I:%M%P',
        'template' => '%date | %title%note',
        'wrap_width' => 0,
        'section' => 'All',
        'count' => 0,
        'order' => 'desc',
        'tags' => 'done complete cancelled',
        'tags_bool' => 'OR'
      },
      'color' => {
          'date_format' => '%F %_I:%M%P',
          'template' => '%boldblack%date %boldgreen| %boldwhite%title%default%note',
          'wrap_width' => 0,
          'section' => 'Currently',
          'count' => 10,
          'order' => "asc"
      }
    }
    @config['marker_tag'] ||= 'flagged'
    @config['marker_color'] ||= 'red'
    @config['default_tags'] ||= []

    @config[:include_notes] ||= true

    File.open(@config_file, 'w') { |yf| YAML::dump(@config, yf) } if @config != user_config || @doingrc_needs_update


    @config = @config.deep_merge(@local_config)

    @current_section = @config['current_section']
    @default_template = @config['templates']['default']['template']
    @default_date_format = @config['templates']['default']['date_format']
  end

  def find_local_config

    config = {}
    dir = Dir.pwd

    local_config_file = nil

    while (dir != '/' && (dir =~ /[A-Z]:\//) == nil)
      if File.exists? File.join(dir, @default_config_file)
        return File.join(dir, @default_config_file)
      end

      dir = File.dirname(dir)
    end

    false
  end

  def read_config
    if Dir.respond_to?('home')
      @config_file = File.join(Dir.home, @default_config_file)
    else
      @config_file = File.join(File.expand_path("~"), @default_config_file)
    end
    @doingrc_needs_update = true if File.exists? @config_file
    additional = find_local_config

    begin
      @config = YAML.load_file(@config_file) || {} if File.exists?(@config_file)
      @local_config = YAML.load_file(additional) || {} if additional
      @config.deep_merge(@local_config)
    rescue
      @config = {}
      @local_config = {}
      # raise "error reading config"
    end
  end

end
