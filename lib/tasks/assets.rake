namespace :assets do
  task precompile: :webpack
end

task :webpack do
  sh "yarn install"
  sh "yarn run compile"
end
