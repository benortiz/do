require 'do'

describe 'Taskpaper::Task' do
  subject do
    Taskpaper::Task.new(project: nil, description: 'something i did', date: Time.new(2018, 9, 17, 20, 4))
  end

  describe '#to_s' do
    it 'formats the date and description into a bullet point' do
      expect(subject.to_s).to eq("\t- 2018-09-17 20:04 | something i did\n")
    end

    it 'formats the date and description into a bullet point with notes below' do
      subject.note.add_line('note!')
      expect(subject.to_s).to eq("\t- 2018-09-17 20:04 | something i did\n\t\tnote!")
    end
  end

  describe '#formatted_date' do
    it 'formats the date according to the config' do
      expect(subject.formatted_date).to eq('2018-09-17 20:04')
    end
  end
end
