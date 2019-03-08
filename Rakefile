require "bundler/gem_tasks"
task :default => :spec

task :console do
  require 'pry'

  def reload!
    files = $LOADED_FEATURES.select { |feat| feat =~ /\/pry\// }
    files.each { |file| load file }
  end

  ARGV.clear
  Pry.start
end