module Taskpaper
  class << self
    def config
      @config ||= Config.new
    end
  end
end

require_relative 'config'
require_relative 'outline'
require_relative 'project'
require_relative 'task'
require_relative 'note'
