Green="\033[0;32m"        # Green
Red="\033[0;31m"          # Red
Color_Off="\033[0m"       # Text Reset

function git_current_branch() {
    git symbolic-ref HEAD 2>/dev/null | awk -F/ '{print $3;}';
}

git branch &>/dev/null
if [ $? -eq 0 ]; then
    echo `git status` | grep "nothing to commit" > /dev/null 2>&1;
    if [ "$?" -eq "0" ]; then
    # @4 - Clean repository - nothing to commit
        echo " \[$Green\](`git_current_branch`)\[$Color_Off\]"
    else
    # @5 - Changes to working tree
        echo -e " \[$Red\](`git_current_branch`)\[$Color_Off\]"
    fi
else
  # @2 - Prompt when not in GIT repo
    echo -n "";
fi
