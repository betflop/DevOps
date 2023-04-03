__oc_ps1()
{
    # Get current context
    CONTEXT=$(cat ~/.kube/config 2>/dev/null| grep -o '^current-context: [^/]*' | cut -d' ' -f2)

    if [ -n "$CONTEXT" ]; then
        echo "(k8s:${CONTEXT})"
    fi
}
# Подсветка веток в консоле
PS1='\[\033[0;32m\]\[\033[0m\033[0;32m\]\u\[\033[0;36m\] @ \[\033[0;36m\]\h \w\[\033[0;32m\]$(__git_ps1) \[\e[1;33m\] $(__oc_ps1) \n\[\033[0;32m\] └─\[\033[0m\033[0;32m\] \$\[\033[0m\033[0;32m\]\[\033[0m\] '

alias tmux="TERM=screen-256color-bce tmux"
