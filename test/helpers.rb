%w{ rubygems bacon metaid }.each { |dep| require dep }
Bacon.extend Bacon::TestUnitOutput
Bacon.summary_on_exit

$:.unshift File.join(File.dirname(__FILE__) , "../lib")
require 'autocode'

