require 'do'

describe 'Taskpaper::Note' do
  describe '#to_s' do
    it 'joins lines in a note with a new line character' do
      expect(
        Taskpaper::Note.new(task: nil, lines: ['note', 'note1']).to_s
      ).to eq("\t\tnote\n\t\tnote1")
    end
  end

  describe '#add_line' do
    it 'appends the line to the lines array' do
      note = Taskpaper::Note.new(task: nil, lines: ['note'])
      note.add_line('note1')
      expect(note.lines).to eq(['note', 'note1'])
    end
  end
end
