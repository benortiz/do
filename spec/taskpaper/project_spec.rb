require 'do'

describe 'Taskpaper::Project' do
  subject do
    Taskpaper::Project.new(name: 'Currently')
  end

  before do
    subject.add_task(
      Taskpaper::Task.new(
        project: subject,
        description: 'something i did',
        date: Time.new(2018, 9, 17, 20, 4)
      )
    )
  end

  describe '#to_s' do
    it 'formats the name and includes all the tasks' do
      expect(subject.to_s).to eq("Currently:\n\t- 2018-09-17 20:04 | something i did\n")
    end
  end

  describe '#add_task' do
    it 'adds a task to the tasks array' do
      task = Taskpaper::Task.new(
        project: subject,
        description: 'another thing i did',
        date: Time.new(2018, 9, 17, 20, 4)
      )
      subject.add_task(task)
      expect(subject.tasks.length).to eq(2)
    end
  end
end
