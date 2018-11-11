# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/nanou/.oh-my-zsh"
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="punctual"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export GCE_CREDENTIALS_FILE='~/ggcloud/ake-ansible-test-provisioner.json'
export GCE_SERVICE_ACCOUNT_EMAIL='provisioner@ake-ansible-test.iam.gserviceaccount.com'
export GCE_PROJECT_ID='ake-ansible-test'
export GCE_SSH_KEY='~/.ssh/akeneo'

# export KUBECONFIG=$KUBECONFIG:$HOME/.kube/config
export GRADLE_HOME='/opt/gradle/gradle-4.8.1'
export PATH=$PATH:/opt/gradle/gradle-4.8.1/bin

ssh-add ~/.ssh/akeneo

alias notif="kdialog --title 'Command finished' --passivepopup 'Your command is finished' 5"
eval $(thefuck --alias)
alias src="source /home/nanou/.bashrc"
alias dev="cd /home/nanou/Developer"
alias ped="cd /home/nanou/Developer/pim-enterprise-dev"
alias ce-in-ee="cd /home/nanou/Developer/pim-enterprise-dev/vendor/akeneo/pim-community-dev"

## DOCKER
alias dcupd="docker-compose up -d"

dockerXdebugOn() {
    if docker-compose exec fpm env | grep -q PHP_XDEBUG_ENABLED=0; then
        sed -i "s/XDEBUG_ENABLED: 0/XDEBUG_ENABLED: 1/g" docker-compose.override.yml
        docker-compose up -d
    fi
}

dockerXdebugOff() {
    if docker-compose exec fpm env | grep -q PHP_XDEBUG_ENABLED=1; then
        sed -i "s/XDEBUG_ENABLED: 1/XDEBUG_ENABLED: 0/g" docker-compose.override.yml
        docker-compose up -d
    fi
}

alias dxdgon='dockerXdebugOn'
alias dxdgoff='dockerXdebugOff'


alias dexec="docker-compose exec"
alias dps="docker-compose ps"
alias fpm="docker-compose exec fpm"
alias dfpm="dxdgoff; dexec fpm"
alias xfpm="dxdgon; dexec fpm"

## SYMFONY
alias sf="dfpm bin/console"
alias xsf="xfpm bin/console"
alias cc="rm -rf var/cache/*"

## PHP
alias composer="dfpm php -d memory_limit=-1 /usr/local/bin/composer"

## PHPSPEC
alias spec="dfpm vendor/bin/phpspec"
alias xspec="xfpm spec"

## PHPUNIT
alias phpunit="dfpm vendor/bin/phpunit -c app/phpunit.xml"

phpunitWithFilter() {
    if [[ "$#" == 2 ]]; then
        export PHPUNIT_TEST_NAME="$2"
    else
        [[ "$#" == 3 ]]
        export PHPUNIT_TEST_NAME="$2"
        export PHPUNIT_INTEGRATION_FILE="$3"
    fi

    if [[ "$1" == "true" ]]; then
        dxdgon
    else
        dxdgoff
    fi
    fpm vendor/bin/phpunit -c app/phpunit.xml --filter "$PHPUNIT_TEST_NAME" "$PHPUNIT_INTEGRATION_FILE"
}
alias phpunit-filter="phpunitWithFilter false"
alias xphpunit-filter="phpunitWithFilter true"


phpunitWithoutFilter() {
    if [[ "$#" == 2 ]]; then
        export PHPUNIT_INTEGRATION_FILE="$2"
    fi

    if [[ "$1" == "true" ]]; then
        dxdgon
    else
        dxdgoff
    fi
    fpm vendor/bin/phpunit -c app/phpunit.xml "$PHPUNIT_INTEGRATION_FILE"
}
alias phpunit="phpunitWithoutFilter false"
alias xphpunit="phpunitWithoutFilter true"

## BEHAT
alias behat="dfpm vendor/bin/behat"
alias xbehat="xfpm vendor/bin/behat"

## PIM
alias pim-install-dep="dxdgoff; bin/docker/pim-dependencies.sh"
alias pim-install="dxdgoff; bin/docker/pim-initialize.sh"
alias pim-install-test="dxdgoff; cc; dbehat; pim-webpacktest"
alias pim-db="sf --env=prod pim:install --force --symlink --clean"
alias pim-db-behat="sf --env=behat pim:installer:db"
alias pim-webpackdev="docker-compose run --rm node yarn run webpack-dev"
alias pim-webpacktest="docker-compose run --rm node yarn run webpack-test"
alias pim-assets="sf --env=prod pim:installer:assets --symlink --clean"
alias pim-front="cc && pim-assets && pim-webpackdev && pim-webpacktest"
alias pim-job-daemon='sf akeneo:batch:job-queue-consumer-daemon --env=prod'
alias pim-job-daemon-once='sf akeneo:batch:job-queue-consumer-daemon --env=prod --run-once'
alias xpim-job-daemon-once='xsf akeneo:batch:job-queue-consumer-daemon --env=prod --run-once'
alias pim-kill-job-daemon='fpm pkill -f job-queue-consumer-daemon'
alias pim-acceptance-front="docker-compose run --rm node yarn run acceptance"
alias pim-front-lint="docker-compose run --rm node yarn run lint"
alias pim-back-lint="dfpm vendor/bin/php-cs-fixer fix --diff --dry-run --config=.php_cs.php --format=junit"
alias pim-back-lint-fix="dfpm vendor/bin/php-cs-fixer fix --diff --config=.php_cs.php"
alias pim-coupling-detector="dfpm vendor/bin/php-coupling-detector detect --config-file=.php_cd.php src"
alias pim-coupling-detector-usermanagement="dfpm vendor/bin/php-coupling-detector detect --config-file=src/Akeneo/UserManagement/.php_cd.php src/Akeneo/UserManagement"
alias pim-coupling-detector-channel="dfpm vendor/bin/php-coupling-detector detect --config-file=src/Akeneo/Channel/.php_cd.php src/Akeneo/Channel"
alias pim-coupling-detector-all="pim-coupling-detector && pim-coupling-detector-usermanagement && pim-coupling-detector-channel"

if [[ ! $TERM =~ screen ]]; then
    exec tmux -u
fi

if [[ -r /usr/local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh ]]; then
source /usr/local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
fi