BUNDLED_COMMANDS="rackup rails rake rspec guard ruby spork thin unicorn annotate"
[ -f $HOME/.bash/bundler-exec.sh ] && source $HOME/.bash/bundler-exec.sh

alias ls-al='ls -al'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias javac='LC_ALL=en javac'

# Git short command alias
alias gs='git status'
alias go='git checkout'
alias ga='git add'
alias gaa='git add --all'
alias gd='git diff'
alias gc='git commit -m'
alias gb='git branch'
alias gph='git push'
alias gpl='git pull'
alias gm='git merge'