require 'server_log_parser'
require 'zlib'
require 'pp'
require 'uri'

path_dict = {}
word_dict = {}
Dir.glob('/var/log/nginx/access.log*') do |file_path|
  puts "analyzing #{file_path}."
  fd = if file_path.include?('gz')
         Zlib::GzipReader.open(file_path)
       else
         File.open(file_path)
       end
  #format = ServerLogParser::COMBINED
  format = '%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\" %D %T'
  parser = ServerLogParser::Parser.new(format)
  fd.read.each_line do |line|
    parsed = parser.parse(line)
    next if parsed.nil?
    next unless parsed['%r'].include?('do=search')

    request = parsed['%r']
    request_type, path, al = request.split
    params = Hash[URI.decode_www_form(path)]
    next if params['id'].nil?
    next if params['id'].empty?
    path = params['id']
    path_dict[path] ||= 0
    path_dict[path] += 1
    next if params['q'].nil?
    next if params['q'].empty?

    word = params['q']
    word_dict[word] ||= 0
    word_dict[word] += 1
  end
end
pp path_dict.sort_by { |_, v| -v }.to_h
pp word_dict.sort_by { |_, v| -v }.to_h
