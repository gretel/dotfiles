begin
  require 'awesome_print'
  AwesomePrint.irb!
rescue LoadError => e
  warn "error: #{e}"
end
