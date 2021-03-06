#!/bin/env ruby

# NOTE:
# For some reason, system calls (`echo foo`, system("echo foo"), etc.)
# break my i3bar setup, since ruby 2.6.
# I really don't know why this is happening, ruby 2.5 works fine,
# but with versions 2.6 and up, you can't click on the i3bar, with this script running,
# without crashing/freezing thr whole i3bar. This is really weird.
# For now, this script just gets the `cmus-remote -Q` output via its first command-line argument.
# Seems to be the easiest fix.
# Very weird.

class CmusRemote
  def self.get_semantic_max_sizes
    max        = SEMANTIC_MAX_TOTAL_SIZE
    multiplier = (SEMANTIC_MAX_TOTAL_SIZE.to_f / 100.0)
    return SEMANTIC_MAX_SIZES_RELATIVE.map do |tag, size_relative|
      size     = (multiplier * size_relative).round
      next [tag, size]
    end .to_h
  end

  DEFAULT_COLOR               = ENV['color'] || '#44AAAA'
  SEMANTIC_TRUNCATE_CHAR      = (ENV['truncate_char']      || ?.).strip
  SEMANTIC_TRUNCATE_CHAR_SIZE = (ENV['truncate_char_size'] || 3 ).to_i
  SEMANTIC_MAX_TOTAL_SIZE     = ENV['max_length'] || 75
  SEMANTIC_MAX_SIZES_RELATIVE = {
    artist: 33.33,
    title:  66.66,
    file:   100.0
  }
  SEMANTIC_MAX_SIZES          = get_semantic_max_sizes
  SEMANTIC_COLOR              = DEFAULT_COLOR
  SEMANTIC_FORMAT             = [ :artist, :title ]
  SEMANTIC_SEPARATOR          = ' — '
  SEMANTIC_TIME_BAR_SEPARATOR = ' <span color="#44AA44" size="smaller"></span> '
  TIME_BAR_COLOR              = '#AA8844'
  TIME_BAR_SIZE               = 8
  TIME_BAR_OUTER_CHARS        = [?◄, ?►]  # [?[, ?]], [?<, ?>], [?, ?], [?▗, ?▖], [?◀, ?▶], [?◂, ?▸], [?◄, ?►], [?◢, ?◣], [?◥, ?◤]
  TIME_BAR_INNER_CHAR         = ?▬        # ?•, ?●, ?#, ?, ?▬, ?■, ?█, ?▄
  TIME_BAR_INNER_BLANK        = ?—        # ?◦, ?○, ?-, ?—, ?▭, ?□, ?▓, ?▒, ?░
  TIME_BAR_POSITION           = :right    # :left
  OUTPUT_PREFIX               = ''        # '<span color="#44AA44" size="smaller"></span> '
  OUTPUT_SUFFIX               = ''        # ' <span color="#44AA44"></span>'
  OUTPUT_PAUSED               = ''        # "<span color='#{DEFAULT_COLOR}'></span>"
  REPLACE_CHARS               = {
    ?& => '&amp;',
    ?< => '&lt;',
    ?> => '&gt;'
  }
  MS_BUTTON = ENV['BLOCK_BUTTON']

  def initialize output
    # handle_ms_button
    @output = output
    # @output = `cmus-remote -Q`.strip  if @output.nil?
    return_output ''  if (@output.empty?)
    handle_output
  end

  def handle_ms_button
    return  if (MS_BUTTON.nil? || MS_BUTTON.empty? || MS_BUTTON == 0)
    ms_button = MS_BUTTON.to_i
    case ms_button
    when 1, 2, 3
      `cmus-remote -u`
    when 4
      `cmus-remote -k +10`
    when 5
      `cmus-remote -k -10`
    end
  end

  def return_output string = '', color = DEFAULT_COLOR
    output = "#{get_prefix || ''}#{string.to_s}#{get_suffix || ''}"
    puts "#{output}\n\n"
    puts color
    exit
  end

  def get_sanatized_string string
    return string.gsub /[#{REPLACE_CHARS.keys.join('')}]/ do |to_replace|
      next REPLACE_CHARS[to_replace]
    end
  end

  def get_prefix
    return OUTPUT_PREFIX
  end

  def get_suffix
    return OUTPUT_SUFFIX
  end

  def handle_output
    case @output.match(/\Astatus (\S+)$/)[1].to_sym
    when :playing
      handle_output_playing
    when :paused
      return_output OUTPUT_PAUSED
    when :stopped
      exit
    end
  end

  def handle_output_playing
    info     = get_cmus_info
    semantic = get_semantic_text_from_info info
    time_bar = get_time_bar_from_info info
    case TIME_BAR_POSITION
    when :left
      output = [
        "<small>",
        "<span color='#{get_sanatized_string TIME_BAR_COLOR}'>",
        "#{get_sanatized_string              time_bar}",
        "</span>",
        "#{                                  SEMANTIC_TIME_BAR_SEPARATOR}",
        "<span color='#{get_sanatized_string SEMANTIC_COLOR}'>",
        "#{get_sanatized_string              semantic}",
        "</span>",
        "</small>"
      ].join('')
    when :right, nil
      output = [
        "<small>",
        "<span color='#{get_sanatized_string SEMANTIC_COLOR}'>",
        "#{get_sanatized_string              semantic}",
        "</span>",
        "#{                                  SEMANTIC_TIME_BAR_SEPARATOR}",
        "<span color='#{get_sanatized_string TIME_BAR_COLOR}'>",
        "#{get_sanatized_string              time_bar}",
        "</span>",
        "</small>"
      ].join('')
    end
    return_output output
  end

  def get_cmus_info
    return (
      @output.scan(/^tag (?<tag>\S+?) (?<body>.+)$/).map do |tag, body|
        next [tag.to_sym, body]
      end .to_h
    ).merge(
      @output.scan(/^(?<name>file|duration|position) (?<body>.+)$/).map do |name, body|
        next [name.to_sym, body]
      end .to_h
    )
  end

  def get_semantic_text_from_info info
    use_filename   = false
    semantic = SEMANTIC_FORMAT.map do |tag|
      next get_truncated_string info[tag], ((SEMANTIC_MAX_SIZES[tag] || 0) - 1)  if (!!info[tag])
      use_filename = true
      next nil
    end .reject { |x| !x } .join(SEMANTIC_SEPARATOR) .strip
    return semantic  unless (use_filename || semantic.empty?)
    return get_truncated_string get_filename_from_info(info), ((SEMANTIC_MAX_SIZES[:file] || 0) - 1)
  end

  def get_truncated_string string, target_index
    return string  if (target_index < 0 || target_index + 1 >= string.size)
    dots = [SEMANTIC_TRUNCATE_CHAR_SIZE, ((string.size - target_index) - 1)].min
    return "#{string[0 .. (target_index - dots)]}#{SEMANTIC_TRUNCATE_CHAR * dots}"
    return string
  end

  def get_filename_from_info info
    filepath = info[:file]
    filename = filepath.split(?/).last.sub(/\.[\w-]+\z/, '')
    return filename
  end

  def get_time_bar_from_info info
    track_length   = info[:duration]
    track_position = info[:position]
    outer_chars    = TIME_BAR_OUTER_CHARS
    inner_char     = TIME_BAR_INNER_CHAR
    inner_size     = TIME_BAR_SIZE - (outer_chars.reduce { |a,b| a.size + b.size })
    inner_blank    = TIME_BAR_INNER_BLANK
    track_percent  = ((track_position.to_f / track_length.to_f) * 100).round
    chars          = ((inner_size.to_f / 100.0) * track_percent).round
    blanks         = inner_size - chars
    time_bar       = "#{outer_chars[0]}#{inner_char * chars}#{inner_blank * blanks}#{outer_chars[1]}"
    return time_bar
  end
end

output = ARGV[0]
cmus_remote = CmusRemote.new output
