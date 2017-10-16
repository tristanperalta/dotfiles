require 'rake'

HOME = ENV['HOME']
ROOT = File.dirname(__FILE__)
SOURCE_FILES = %w( bashrc gemrc gitconfig hgrc tmux.conf )

def symlink_cmd(filename)
  "ln -sf #{ROOT}/#{filename} #{HOME}/.#{filename}"
end

dotfiles = SOURCE_FILES.map do |file|
    "#{HOME}/.#{file}"
  end

task :default => :install
task :install => dotfiles
task :clean do
  sh "rm #{dotfiles.join(' ')}"
end

%w{ bashrc gemrc gitconfig hgrc tmux.conf bash_aliases }.each do |rc|
  file "#{HOME}/.#{rc}" => rc do
    sh symlink_cmd(rc)
  end
end
