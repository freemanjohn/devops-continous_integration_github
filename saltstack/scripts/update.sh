if [ "${{ github.event.repository.name }}" =~ "salt_states" ]; then
    salt-run cache.clear_git_lock gitfs type=update
    salt-run fileserver.update -l debug
elif [ "${{ github.event.repository.name }}" =~ "salt_pillar" ]; then
    salt-run git_pillar.update -l debug
else
    echo "+ Unkonwn project type executed"
fi