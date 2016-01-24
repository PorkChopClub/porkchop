namespace :assets do
  task :precompile => :webpack
end

task :webpack do
  sh "npm install"
  sh "npm run compile"
end
