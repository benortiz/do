require 'do'

describe 'Taskpaper::Outline' do
  subject do
    Taskpaper::Outline.new(raw_content: "Currently:\n\t- 2018-09-17 20:04 | something i did\n")
  end
  describe '#to_structure' do
    it 'takes a string and breaks it into an array of projects' do
      expect(subject.to_structure.length).to eq(1)
    end
  end

  describe '#to_s' do
    it 'turns every project into a string' do
      expect(subject.to_s).to eq("Currently:\n\t- 2018-09-17 20:04 | something i did\n")
    end
  end
end
