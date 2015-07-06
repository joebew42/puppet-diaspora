require 'bundler'
Bundler.require(:rake)
require 'rake/clean'

require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'

task :librarian_spec_prep do
 sh "librarian-puppet install --path=spec/fixtures/modules"
end
task :spec_prep => :librarian_spec_prep
