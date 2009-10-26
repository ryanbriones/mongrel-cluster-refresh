require 'rubygems'
require 'rake/gempackagetask'
 
spec = Gem::Specification.new do |s|
  s.name = 'mongrel-cluster-refresh'
  s.version = '0.0.2'
  s.homepage = 'http://github.com/ryanbriones/mongrel-cluster-refresh'
  s.summary = 'Send graceful restart signal to most resource intensive processes in a mongrel cluster'
  s.files = FileList['[A-Z]*', 'lib/mongrel-cluster-refresh/init.rb']
  s.autorequire = 'init.rb'
  s.has_rdoc = false
  s.author = 'Ryan Carmelo Briones'
  s.email = 'ryan.briones@brionesandco.com'

  s.add_dependency 'gem_plugin', '>=0.1'
  s.add_dependency 'mongrel', '>=0.3.9'
end
 
package_task = Rake::GemPackageTask.new(spec) {}
 
task :build_gemspec do
  File.open("#{spec.name}.gemspec", "w") do |f|
    f.write spec.to_ruby
  end
end
 
task :default => [:build_gemspec, :gem]
