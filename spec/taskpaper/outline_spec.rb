require 'do'

describe 'Taskpaper::Outline' do
  subject do
    Taskpaper::Outline.new(raw_content: "Currently:\n\t- 2018-09-17 20:04 | something i did\n")
  end
  describe '#projects' do
    it 'takes a string and breaks it into an array of projects' do
      expect(subject.projects.length).to eq(1)
    end
  end

  describe '#to_s' do
    it 'turns every project into a string' do
      expect(subject.to_s).to eq("Currently:\n\t- 2018-09-17 20:04 | something i did\n")
    end
  end

  describe '#find_project' do
    it 'finds a project in an outline by name' do
      expect(subject.find_project('Currently')).to be
    end
  end

  describe '#add_project' do
    it 'appends a project to the taskpaper outline' do
      subject.add_project(Taskpaper::Project.new(name: 'New Project'))
      expect(subject.projects.length).to eq(2)
    end
  end

  describe '#tasks' do
    it 'lists all the tasks in all the projects' do
      expect(subject.tasks.length).to eq(1)
    end
  end

end
