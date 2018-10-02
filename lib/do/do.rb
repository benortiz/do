module Do
  class << self
    def config
      c = Config.new
      @config ||= c.attributes
    end
  end
end

require_relative 'version'
require_relative 'cmd'
require_relative 'config'
