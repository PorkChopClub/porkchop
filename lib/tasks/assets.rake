namespace :assets do
  task precompile: :webpack
end

task :webpack do
  sh "npm install"
  if Rails.env.production?
    sh "NODE_ENV=production npm run compile"
  else
    sh "npm run compile"
  end
end
