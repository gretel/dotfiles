# hit Enter to repeat last command
Pry::Commands.command /^$/, "repeat last command" do
  _pry_.run_command Pry.history.to_a.last
end

# Pry.commands.alias_command 'c', 'continue' rescue nil
# Pry.commands.alias_command 's', 'step' rescue nil
# Pry.commands.alias_command 'n', 'next' rescue nil
# Pry.commands.alias_command 'r!', 'reload!' rescue nil

Pry.editor = 'vim'

Pry.config.color = true
Pry.config.theme = 'pry-modern-256'

# This prompt shows the ruby version (useful for RVM)
Pry.prompt = [proc { |obj, nest_level, _| "#{RUBY_VERSION} (#{obj}):#{nest_level} > " }, proc { |obj, nest_level, _| "#{RUBY_VERSION} (#{obj}):#{nest_level} * " }]

Pry.config.ls.separator = "\n" # new lines between methods
Pry.config.ls.heading_color = :magenta
Pry.config.ls.public_method_color = :green
Pry.config.ls.protected_method_color = :yellow
Pry.config.ls.private_method_color = :bright_black

begin
  require 'pry-clipboard'
  Pry.config.commands.alias_command 'ch', 'copy-history'
  Pry.config.commands.alias_command 'cr', 'copy-result'
rescue LoadError => e
  warn "error: #{e}"
end

# Stolen from https://gist.github.com/807492
# Use Array.toy or Hash.toy to get an array or hash to play with
class Array
  def self.toy(n=10, &block)
    block_given? ? Array.new(n,&block) : Array.new(n) {|i| i+1}
  end
end

class Hash
  def self.toy(n=10)
    Hash[Array.toy(n).zip(Array.toy(n){|c| (96+(c+1)).chr})]
  end
end

# Everything below this line is for customizing colors, you have to use the ugly
# color codes, but such is life.
CodeRay.scan("example", :ruby).term # just to load necessary files
# Token colors pulled from: https://github.com/rubychan/coderay/blob/master/lib/coderay/encoders/terminal.rb

TERM_TOKEN_COLORS = {
  :debug => "\e[1;37;44m",

  :annotation => "\e[34m",
  :attribute_name => "\e[35m",
  :attribute_value => "\e[31m",
  :binary => {
    :self => "\e[31m",
    :char => "\e[1;31m",
    :delimiter => "\e[1;31m",
  },
  :char => {
    :self => "\e[35m",
    :delimiter => "\e[1;35m"
  },
  :class => "\e[1;35;4m",
  :class_variable => "\e[36m",
  :color => "\e[32m",
  :comment => {
    :self => "\e[1;30m",
    :char => "\e[37m",
    :delimiter => "\e[37m",
  },
  :constant => "\e[1;34;4m",
  :decorator => "\e[35m",
  :definition => "\e[1;33m",
  :directive => "\e[33m",
  :docstring => "\e[31m",
  :doctype => "\e[1;34m",
  :done => "\e[1;30;2m",
  :entity => "\e[31m",
  :error => "\e[1;37;41m",
  :exception => "\e[1;31m",
  :float => "\e[1;35m",
  :function => "\e[1;34m",
  :global_variable => "\e[1;32m",
  :hex => "\e[1;36m",
  :id => "\e[1;34m",
  :include => "\e[31m",
  :integer => "\e[1;34m",
  :imaginary => "\e[1;34m",
  :important => "\e[1;31m",
  :key => {
    :self => "\e[35m",
    :char => "\e[1;35m",
    :delimiter => "\e[1;35m",
  },
  :keyword => "\e[32m",
  :label => "\e[1;33m",
  :local_variable => "\e[33m",
  :namespace => "\e[1;35m",
  :octal => "\e[1;34m",
  :predefined => "\e[36m",
  :predefined_constant => "\e[1;36m",
  :predefined_type => "\e[1;32m",
  :preprocessor => "\e[1;36m",
  :pseudo_class => "\e[1;34m",
  :regexp => {
    :self => "\e[35m",
    :delimiter => "\e[1;35m",
    :modifier => "\e[35m",
    :char => "\e[1;35m",
  },
  :reserved => "\e[32m",
  :shell => {
    :self => "\e[33m",
    :char => "\e[1;33m",
    :delimiter => "\e[1;33m",
    :escape => "\e[1;33m",
  },
  :string => {
    :self => "\e[31m",
    :modifier => "\e[1;31m",
    :char => "\e[1;35m",
    :delimiter => "\e[1;31m",
    :escape => "\e[1;31m",
  },
  :symbol => {
    :self => "\e[33m",
    :delimiter => "\e[1;33m",
  },
  :tag => "\e[32m",
  :type => "\e[1;34m",
  :value => "\e[36m",
  :variable => "\e[34m",

  :insert => {
    :self => "\e[42m",
    :insert => "\e[1;32;42m",
    :eyecatcher => "\e[102m",
  },
  :delete => {
    :self => "\e[41m",
    :delete => "\e[1;31;41m",
    :eyecatcher => "\e[101m",
  },
  :change => {
    :self => "\e[44m",
    :change => "\e[37;44m",
  },
  :head => {
    :self => "\e[45m",
    :filename => "\e[37;45m"
  },
}

module CodeRay
    module Encoders
        class Terminal < Encoder
            # override old colors
            TERM_TOKEN_COLORS.each_pair do |key, value|
                TOKEN_COLORS[key] = value
            end
        end
    end
end
