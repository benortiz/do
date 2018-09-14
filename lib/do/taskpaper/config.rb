class Taskpaper::Config
  attr_accessor :date_format

  def initialize
    self.date_format = '%Y-%m-%d %H:%M'
  end
end
