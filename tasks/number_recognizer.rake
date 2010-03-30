namespace :nr do
  desc 'Update number_recognizer plugin'
  task :safe_update do
    system "script/plugin install -f git://github.com/Narnach/number_recognizer.git"
  end

  desc 'Update number_recognizer plugin and auto-commit it to git.'
  task :update do
    system "script/plugin install -f git://github.com/Narnach/number_recognizer.git && git add vendor/plugins/number_recognizer && git commit -m 'Updated number_recognizer to latest version'"
  end
end