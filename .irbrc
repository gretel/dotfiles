begin
  require 'hirb'
  require 'awesome_print'
rescue LoadError => e
  warn "LoadError: #{e}"
end

begin
  Hirb.enable
  AwesomePrint.irb!
rescue NameError => e
  warn "NameError: #{e}"
end
