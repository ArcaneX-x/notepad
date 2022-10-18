if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [$stdin, $stdout].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

require_relative 'post'
require_relative 'memo'
require_relative 'link'
require_relative 'task'
require 'optparse'

options = {}

OptionParser.new do |opt|
  opt.banner = 'Usage: read.rb [options]'

  opt.on('-h', 'Prints this help') do
    puts opt
    exit
  end

  opt.on('--type POST_TYPE', 'Which type of post ' \
         '(by default any)') { |o| options[:type] = o }

  opt.on('--id POST_ID', 'if we have id — show details ' \
         ' тonly this post ID') { |o| options[:id] = o }

  opt.on('--limit NUMBER', 'How many posts to show? ' \
         '(by default all)') { |o| options[:limit] = o }
end.parse!

result_id = Post.find_by_id(options[:id])
result_all = Post.find_all(options[:limit], options[:type])

if !result_id.nil?
  puts "Note #{result_id.class.name}, id = #{options[:id]}"
  result_id.to_strings.each { |line| puts line }
else
  print '| id                 '
  print '| @type              '
  print '| @created_at        '
  print '| @text              '
  print '| @url               '
  print '| @due_date          '
  print '|'

  result_all.each do |row|
    puts
    row.each do |element|
      element_text = "| #{element.to_s.delete("\n")[0..17]}"
      element_text << ' ' * (21 - element_text.size)
      print element_text
    end

    print '|'
  end
  puts
end
