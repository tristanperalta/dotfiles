require 'rake'

HOME = ENV['HOME']
ROOT = File.dirname(__FILE__)

def symlink_cmd(filename)
  "ln -sf #{ROOT}/#{filename} #{HOME}/.#{filename}"
end

raw_files = %w( bashrc gemrc gitconfig hgrc tmux.conf )

dotfiles = raw_files.map do |file|
    "#{HOME}/.#{file}"
  end

dotfiles << "#{HOME}/.config/fish/config.fish"

task :default => :install
task :install => dotfiles
task :clean do
  sh "rm #{dotfiles.join(' ')}"
end

file "#{HOME}/.bashrc" => "bashrc" do
  sh symlink_cmd('bashrc')
end

file "#{HOME}/.gemrc" => "gemrc" do
  sh symlink_cmd('gemrc')
end

file "#{HOME}/.gitconfig" => "gitconfig" do
  sh symlink_cmd('gitconfig')
end

file "#{HOME}/.gitignore" => "gitignore" do
  sh symlink_cmd('gitignore')
end

file "#{HOME}/.hgrc" => "hgrc" do
  sh symlink_cmd('hgrc')
end

file "#{HOME}/.tmux.conf" => "tmux.conf" do
  sh symlink_cmd('tmux.conf')
end

file "#{HOME}/.config/fish/config.fish" => "config.fish" do
  sh "ln -sf #{ROOT}/config.fish #{HOME}/.config/fish/config.fish"
end
