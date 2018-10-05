require 'byebug'
require 'quiver_note'

module Storage::Quiver
  module_function

  def wdid
    if wdid_note
      wdid_note.content["cells"][0]["data"]
    end
  end

  def setup_wdid(contents)
    byebug
    if !wdid_note
      write(contents)
    end
  end

  def write(contents)
    quiver_notebook.add(wdid_note(contents))
    wdid_note
  end

  def quiver_library
    Quiver.local(File.expand_path(Do.config.storage[:quiver][:library]))
  end

  def quiver_notebook
    quiver_library.notebook(Do.config.storage[:quiver][:notebook])
  end

  def wdid_note
    note = nil
    quiver_notebook.each do |qnote|
      note = qnote if qnote.title == Do.config.storage[:quiver][:note_name]
    end
    note
  end
end
