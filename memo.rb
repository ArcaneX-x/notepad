class Memo < Post
  def read_from_console
    puts 'New note (Write lines. To stop write "end"):'
    line = nil
    until line == 'end'
      line = $stdin.gets.chomp
      @text << line
    end
    @text.pop
  end

  def to_strings
    time_string = "Created: #{@created_at.strftime('%Y.%m.%d, %H:%M:%S')}\n"
    @text.unshift(time_string)
  end

  def to_db_hash
    super.merge('text' => @text.join('\n'))
  end

  def load_data(data_hash)
    super
    @text = data_hash['text'].split('\n')
  end
end
