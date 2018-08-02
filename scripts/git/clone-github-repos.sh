repos=$(curl https://api.github.com/users/scuba10steve/repos)

for repo in $(echo $repos | jq .[].git_url); do
    pushd /home/vagrant/git/playground
        git clone $repo
    popd 
done