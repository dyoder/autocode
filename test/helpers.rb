%w{ rubygems bacon}.each { |dep| require dep }
Bacon.extend Bacon::TestUnitOutput
Bacon.summary_on_exit

$:.unshift File.join(File.dirname(__FILE__) , "lib")
require 'autocode'

# Dir.chdir(File.dirname(__FILE__))