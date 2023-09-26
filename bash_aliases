alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias terraform=$HOME/.tfenv/bin/terraform
alias tf=$HOME/.tfenv/bin/terraform
alias tg=terragrunt
alias kctl=kubectl
alias kc=kubectl
alias tfenv=$HOME/.tfenv/bin/tfenv

if command -v nvim > /dev/null; then
  alias vim=nvim
fi
export WIN_USER=/mnt/c/Users/mevmh

get_kubectl_secret() {
  local namespace=''
  while [ $# -gt 0 ]; do
    case "$1" in
      -n|--namespace)
        namespace="$2"
        shift
        shift
      ;;
      *)
        break
      ;;
    esac
  done

  if [ ! -z $namespace ]; then
    namespace="-n $namespace"
  fi
  echo "kubectl get secret $namespace $1 -o json | jq1.6 '.data | map_values(@base64d)'"
  kubectl get secret ${=namespace} $1 -o json | jq1.6 '.data | map_values(@base64d)'
}

gitmerge() {
  gitsync "$1"
  if [ $? -ne 0 ]; then
    echo "gitsync failed"
    return 1
  fi

  local prlink=$(hub pull-request -m "$2")
  local merge_endpoint=$(echo $prlink | sed -r -e 's|https://github.com/(.+)/(.+)/pull/([[:digit:]]+)|/repos/\1/\2/pulls/\3/merge|')
  hub api -X PUT $merge_endpoint
}
