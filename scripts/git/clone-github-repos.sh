repos=$(curl https://api.github.com/users/scuba10steve/repos)

pushd /home/vagrant/git/playground
    for repo in $(echo $repos | jq .[].clone_url -r); do
            git clone $repo
    done
popd 