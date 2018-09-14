module Do
  class << self
    def config
      @config ||= Config.new
    end
  end
end

require_relative 'version'
require_relative 'config'
