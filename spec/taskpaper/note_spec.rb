require 'do'

describe 'Taskpaper::Note' do
  it 'initializes' do
    expect{Taskpaper::Note.new(task: nil)}.not_to raise_error
  end
end
