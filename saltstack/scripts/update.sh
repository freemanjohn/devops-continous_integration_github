if [[ "$CI_PROJECT_NAME" =~ "salt_states" ]]; then
    SALT_STATE_CLEAR_CACHE="salt-run cache.clear_git_lock gitfs type=update"
    SALT_STATE_UPDATE="salt-run fileserver.update -l debug"
    echo "+ Running command [$SALT_STATE_CLEAR_CACHE]"
    $SALT_STATE_CLEAR_CACHE
    echo "+ Running command [$SALT_STATE_UPDATE]"
    $SALT_STATE_UPDATE
elif [[ "$CI_PROJECT_NAME" =~ "salt_pillar" ]]; then
    SALT_PILLAR_UPDATE="salt-run git_pillar.update -l debug"
    echo "+ Running command [$SALT_PILLAR_UPDATE]"
    $SALT_PILLAR_UPDATE
else
    echo "+ Unkonwn project type executed"
fi