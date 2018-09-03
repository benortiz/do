class Taskpaper
  attr_accessor :raw_data, :other_content_bottom, :other_content_top, :date_format

  def initialize(raw_data)
    self.raw_data = raw_data
    self.other_content_top = []
    self.other_content_bottom = []
  end

  def to_h
    content = {}
    section = "Uncategorized"
    current = 0

    lines.each do |line|
      next if line =~ /^\s*$/
      if line =~ /^(\S[\S ]+):\s*(@\S+\s*)*$/
        section = $1
        content[section] = {}
        content[section]['original'] = line
        content[section]['items'] = []
        current = 0
      elsif line =~ /^\s*- (\d{4}-\d\d-\d\d \d\d:\d\d) \| (.*)/
        date = Time.parse($1)
        title = $2
        content[section]['items'].push({'title' => title, 'date' => date, 'section' => section})
        current += 1
      else
        if current == 0
          other_content_top.push(line)
        else
          if line =~ /^\S/
            other_content_bottom.push(line)
          else
            unless content[section]['items'][current - 1].has_key? 'note'
              content[section]['items'][current - 1]['note'] = []
            end
            content[section]['items'][current - 1]['note'].push(line.gsub(/ *$/,''))
          end
        end
      end
    end
    content
  end

  def to_s
    unless self.other_content_top
      output = ""
    else
      output = self.other_content_top.join("\n") + "\n"
    end
    self.to_h.each do |title, section|
      output += section['original'] + "\n"
      output += format_items(
        section['items'],
        {:section => title, :template => "\t- %date | %title%note", :highlight => false}
      )
    end
    output += self.other_content_bottom.join("\n") unless self.other_content_bottom.nil?
    output
  end

  def format_items(items, opt={})
    out = ""
    items.each do |item|
      output = opt[:template].dup

      output.sub!(/%date/, item['date'].strftime(self.date_format))

      output.sub!(/%title/) do |m|
        item['title'].chomp
      end

      if (item.has_key?('note') && !item['note'].empty?)
        note_lines = item['note'].delete_if do |line|
          line =~ /^\s*$/
        end.map do |line|
          "\t" + line.sub(/^\t*/,'') + "  "
        end
        note = "\n#{note_lines.join("\n").chomp}"
      else
        note = ""
      end
      output.sub!(/%note/,note)


      out += output + "\n"
    end
    return out
  end

  def add_section(section_name)
    self.to_h.merge!({
      section_name.cap_first => {
        'original' => "#{section_name}:",
        'items' => []
      }
    })
  end

  def find_section(section_name)
    return "All" if section_name =~ /all/i

    # Return exact match if found
    sections.each do |section|
      return section.cap_first if section_name.downcase == section.downcase
    end

    # Return a fuzzy match as a backup
    regex = section_name.split('').join(".*?")
    sections.each do |section|
      if section =~ /#{regex}/i
        $stderr.puts "Assuming you meant #{section}"
        return section
      end
    end
    nil
  end

  def guess_section(frag,guessed=false)
    return "All" if frag =~ /all/i
    sections.each {|section| return section.cap_first if frag.downcase == section.downcase }
    section = false
    re = frag.split('').join(".*?")
    sections.each {|sect|
      if sect =~ /#{re}/i
        $stderr.puts "Assuming you meant #{sect}"
        section = sect
        break
      end
    }
    unless section || guessed
      alt = guess_view(frag,true)
      if alt
        raise "Did you mean `doing view #{alt}`?"
      else
        print "Create a new section called #{frag.cap_first} (y/N)?"
        input = STDIN.gets
        if input =~ /^y/i
          add_section(frag.cap_first)
          write(@doing_file)
          return frag.cap_first
        end
        raise "Unknown section: #{frag}"
      end
    end
    section ? section.cap_first : guessed
  end

  private

  def lines
    @lines ||= self.raw_data.split(/[\n\r]/)
  end

  def sections
    @sections ||= self.to_h.keys
  end
end
