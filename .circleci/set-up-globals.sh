#!/bin/bash

TERMINUS_PROJECT_PATH="${HOME}/terminus"

#=====================================================================================================================
# EXPORT needed environment variables
#
# Circle CI 2.0 does not yet expand environment variables so they have to be manually EXPORTed
# Once environment variables can be expanded this section can be removed
# See: https://discuss.circleci.com/t/unclear-how-to-work-with-user-variables-circleci-provided-env-variables/12810/11
# See: https://discuss.circleci.com/t/environment-variable-expansion-in-working-directory/11322
# See: https://discuss.circleci.com/t/circle-2-0-global-environment-variables/8681
#=====================================================================================================================
mkdir -p $(dirname $BASH_ENV)
touch $BASH_ENV
(
  echo 'export PATH=$PATH:$HOME/bin'
  echo 'export PATH=$PATH:$HOME/bin'
  echo "export TERMINUS_PROJECT_PATH=${TERMINUS_PROJECT_PATH}"
  echo 'export TERMINUS_HIDE_UPDATE_MESSAGE=1'
) >> $BASH_ENV
source $BASH_ENV

set +ex
echo "Test site is $TERMINUS_SITE"
echo "Logging in with a machine token:"
terminus auth:login -n --machine-token="$TERMINUS_TOKEN"
terminus whoami
touch $HOME/.ssh/config
echo "StrictHostKeyChecking no" >> "$HOME/.ssh/config"
echo "${CI_PUBLIC_KEY}" > "%{HOME}/.ssh/id_rsa.pub"
echo "${CI_PRIVATE_KEY}" > "%{HOME}/.ssh/id_rsa"
git config --global user.email "$GIT_EMAIL"
git config --global user.name "Circle CI"
# Ignore file permissions.
git config --global core.fileMode false

# This is just to access terminus dev dependencies.
mkdir ${TERMINUS_PROJECT_PATH}
cd ${TERMINUS_PROJECT_PATH}
git clone https://github.com/pantheon-systems/terminus.git
cd terminus
composer install
