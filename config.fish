set -x EDITOR nvim
set -x PATH $PATH $HOME/.rbenv/bin

status --is-interactive; and . (rbenv init -|psub)

function _git_branch_name
  echo (git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function fish_prompt
  set -l cyan (set_color cyan)
  set -l red (set_color red)
  set -l normal (set_color normal)
  set -l arrow "$red➜"
  set -l cwd $cyan(pwd)

  if [ (_git_branch_name) ]
    set -l git_branch $red(_git_branch_name)$cyan
    set git_info "git:($git_branch)"
  end

  echo -n -s "$cwd $git_info"
  echo -e "\n$arrow $normal"
end

function t
  command tmux $argv
end

function gk
  command gitk&
end

function be
  command bundle exec $argv
end

function fish_greeting
  fortune | cowsay
end
