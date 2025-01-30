if status is-interactive
    # Commands to run in interactive sessions can go here
end

function jqq
    jq -C $argv | less -FR
end

set -g fish_greeting

# pnpm
set -gx PNPM_HOME "/Users/pablo/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

contains /usr/local/opt/mysql-client/bin $fish_user_paths; or set -Ua fish_user_paths /usr/local/opt/mysql-client/bin

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish ; or true

