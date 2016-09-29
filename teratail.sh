# @(#) This script is tetarail command line viewer.

__teratail::lower() {
  printf "$1\n" | tr '[A-Z]' '[a-z]'
}

__teratail::os_type() {
  if [[ "$(uname)" == 'Darwin' ]]; then
    __teratail::lower 'Osx'
  elif [[ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]]; then
    __teratail::lower 'Linux'
  elif [[ "$(expr substr $(uname -s) 1 10)" == 'MINGW32_NT' ]]; then
    __teratail::lower 'Cygwin'
  fi
}

__teratail::is_osx() {
  [[ `os_type` == "osx" ]] && return true || return false
}

__teratail::is_linux() {
  [[ `os_type` == "linux" ]] && return true || return false
}

__teratail::is_cygwin() {
  [[ `os_type` == "cygwin" ]] && return true || return false
}

__teratail::curl()
{
  if [ -z $TERATAIL_API_TOKEN ]; then
    printf "Warning: should set env TERATAIL_API_TOKEN"
    curl -X $1 $2
  elif
    curl -X $1 \
      -H "Authorization: Bearer $TERATAIL_API_TOKEN" \
      $2
  fi
}

__teratail::has_command()
{
  type $1 &>/dev/null
  (( $? == 0 )) && true || false
}

__teratail::need_install()
{
  if ! __teratail::has_command $1; then
    printf "Need to install $1"
    __teratail::help 0
  fi
}

__teratail::run()
{
  json=$(__teratail::curl GET 'https://teratail.com/api/v1/questions?limit=100')
  questions=$(cat <<< $json | jq '.questions | map ({ id: .id, title: .title })')
  local q k title_of_selected
  while out=$(
      cat <<< $questions \
            | jq '.[] | "\(.id) \(.title)"' \
            | tr -d '"' \
            | fzf --ansi --no-sort --reverse --query="$q" \
                  --print-query --expect=ctrl-f,ctrl-o);
  do
    q=$(head -1 <<< "$out")
    k=$(head -2 <<< "$out" | tail -1)
    title_of_selected=$(sed '1,2d' <<< "$out")
    [ -z "$title_of_selected" ] && continue
    id=$(awk '{print $1}' <<< $title_of_selected)
    if [ "$k" = ctrl-o ]; then
      opener https://teratail.com/questions/$id &
    else
      data=$(__teratail::curl GET "https://teratail.com/api/v1/questions/$id" \
        | jq '.question | "\(.body)"' | sed -e 's/\\n\\r//g')

      echo $data | less

    fi
  done
}

__teratail::help()
{
  if (( $1 > 0 )); then
    printf "Error: Wrong number of arguments. Expected 0, got $#\n"
  fi
  cat <<HELP
Usage:
  teratail [OPTIONS]

Config:

  .bashrc

  export TERATAIL_API_TOKEN="0123456789abcdef0123456789abcdef0123456789"

Options:
  -h, --help Show help message

Requirement:
  jq         https://github.com/stedolan/jq#jq
  fzf        https://github.com/junegunn/fzf#installation
  opener     https://www.npmjs.com/package/opener

Author:      maxmellon
HELP

  return 1
}

teratail()
{
  case $# in
    0 )
      __teratail::need_install opener || return 1
      __teratail::need_install fzf || return 1
      __teratail::need_install jq || return 1

      LANG=ja_JP.UTF-8 __teratail::run
      ;;

    * )
      if [[ $1 =~ '--help$|-h$' ]]; then
        __teratail::help 0 || return 0
      else
        __teratail::help $# || return 1
      fi
      ;;
  esac
}

# vim: ft=zsh sw=2 et
