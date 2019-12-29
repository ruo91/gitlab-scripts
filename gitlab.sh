#---------------------------------------------------#
# - Title
#     GitLab Init Start Script
#
# - Production
#     GitLab Community Edition
#
# - Version
#     latest
#
#- OS Supported
#     RHEL / CentOS/ Fedora
#
# - Maintainer
#     Yongbok Kim (ruo91@yongbok.net)
#
# - Ref URL
#     https://github.com/ruo91/gitlab-scripts.git
#
#---------------------------------------------------#
#!/bin/bash
export PATH=$PATH

# Gitlab Default
GITLAB_NAME="gitlab"
GITLAB_MODE="always"
GITLAB_HOSTNAME="gitlab.example.com"
GITLAB_IMG="docker.io/gitlab/gitlab-ce:latest"
GITLAB_HTTP_PORT="80"
GITLAB_HTTPS_PORT="443"
CONTAINER_GITLAB_HTTP_PORT="80"
CONTAINER_GITLAB_HTTPS_PORT="443"

# Gitlab Volume (Host)
HOST_GITLAB_DIR="/opt/gitlab"
HOST_GITLAB_ETC_DIR="$HOST_GITLAB_DIR/etc/gitlab"
HOST_GITLAB_LOG_DIR="$HOST_GITLAB_DIR/var/log/gitlab"
HOST_GITLAB_OPT_DIR="$HOST_GITLAB_DIR/var/opt/gitlab"

# Gitlab Volume (Container)
CONTAINER_GITLAB_ETC_DIR="/etc/gitlab"
CONTAINER_GITLAB_LOG_DIR="/var/log/gitlab"
CONTAINER_GITLAB_OPT_DIR="/var/opt/gitlab"

#### Functions ####
## Checking - SELinux
# https://github.com/xieyushi/blog/issues/4
function f_selinux_check {
    # Checking SELinux
    if [[ "$(getenforce)" -eq "Enforcing" ]]; then
        chcon -Rt svirt_sandbox_file_t $HOST_GITLAB_DIR
    fi
}

## Checking - Gitlab directory
function f_init_gitlab_dir {
  # Checking gitlab directory
  if [[ -d "$HOST_GITLAB_DIR" ]]; then
      # Checking SELinux
      f_selinux_check

  else
      # Create gitlab directory
      mkdir -p $HOST_GITLAB_DIR/{etc/gitlab,var/log/gitlab,var/opt/gitlab}

      # Checking SELinux
      f_selinux_check
  fi
}

## Initialization gitlab
function f_gitlab_init_start {
    docker run -d \
    --name $GITLAB_NAME \
    --restart $GITLAB_MODE \
    --hostname $GITLAB_HOSTNAME \
    --publish $GITLAB_HTTP_PORT:$CONTAINER_GITLAB_HTTP_PORT \
    --publish $GITLAB_HTTPS_PORT:$CONTAINER_GITLAB_HTTPS_PORT \
    -v $HOST_GITLAB_ETC_DIR:$CONTAINER_GITLAB_ETC_DIR \
    -v HOST_GITLAB_LOG_DIR:$CONTAINER_GITLAB_LOG_DIR \
    -v HOST_GITLAB_OPT_DIR:$CONTAINER_GITLAB_OPT_DIR \
    $GITLAB_IMG > /dev/null 2>&1

    echo 'Initialization gitlab: Done'
}

## Gitlab start
function f_gitlab_already_conatiner_start {
    docker start $GITLAB_NAME > /dev/null 2>&1
    echo 'Gitlab Start: Done'
}

## Gitlab stop
function f_gitlab_already_container_stop {
    docker stop $GITLAB_NAME > /dev/null 2>&1
    echo 'Gitlab Stop: Done'
}

## Gitlab logs
function f_gitlab_already_container_logs {
    docker logs -f $GITLAB_NAME
}

## Gitlab rm
function f_gitlab_already_container_rm {
    f_gitlab_already_container_stop
    docker rm $GITLAB_NAME > /dev/null 2>&1
    echo 'Gitlab Remove: Done'
}

function f_help {
  echo "Usage: $ARG_0 [Arguments]"
  echo
  echo "- Arguments"
  echo "i, init		: Initialization gitlab & Auto Start"
  echo "s, start	: Gitlab Container(Already Only) Start"
  echo "st, stop	: Gitlab Container(Already Only) Stop"
  echo "l, logs		: Gitlab Container(Already Only) Log View"
  echo "r, rm		: Gitlab Container(Already Only) Remove"
  echo
}

# Main
ARG_0="$0"
ARG_1="$1"

case ${ARG_1} in
  i|init)
      f_init_gitlab_dir
      f_gitlab_init_start
  ;;

  s|start)
      f_gitlab_already_conatiner_start
  ;;

  st|stop)
      f_gitlab_already_container_stop
  ;;

  l|logs)
      f_gitlab_already_container_logs
  ;;

  r|rm)
      f_gitlab_already_container_rm
  ;;

  *)
    f_help
  ;;
esac
