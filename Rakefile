require 'rake'

desc "Install dot files into user's directory"
task :install do
  replace_all = false
  Dir['*'].each do |file|
    next if %w{Rakefile bash}.include? file
    if File.exists?(File.join(ENV['HOME'], ".#{file}"))
      if File.identical? file, File.join(ENV['HOME'], ".#{file}")
        puts "identical ~/.#{file}"
      elsif replace_all
        replace_file(file)
      else
        print "overwrite ~/.#{file}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_file(file)
        when 'y'
          replace_file(file)
        when 'q'
          exit
        else
          puts "skipping ~/.#{file}"
        end
      end
    else
      link_file(file)
    end
  end
end

desc "Uninstall dot files into user's directory"
task :uninstall do
  Dir['*'].each do |file|
    next if %w{Rakefile bash}.include? file
    remove_file file
  end
end

def remove_file(file)
  puts "Removing file #{file}"
  system %Q{rm -rf "$HOME/.#{file}"}
end

def link_file(file)
  puts "linking ~/.#{file}"
  system %Q{ln -s "$PWD/#{file}" "$HOME/.#{file}"}
end

def replace_file(file)
  remove_file(file)
  link_file(file)
end
