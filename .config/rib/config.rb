require 'rib/core'

require 'rib/extra/autoindent'
require 'rib/extra/hirb'
require 'rib/extra/paging'

require 'rib/more/anchor'
require 'rib/more/color'

require 'rubygems'
require 'awesome_print'

puts "ruby #{RUBY_VERSION} #{RUBY_REVISION} #{RUBY_PLATFORM} #{RUBY_RELEASE_DATE}"

# Rib.config[:prompt] = '$ '

module RibPP
  Rib::Shell.send(:include, self)

  def format_result result
    "#{result_prompt} #{ap(result)}"
  end
end
