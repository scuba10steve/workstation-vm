if [[ $(which dos2unix) ]]; then
    dos2unix *
    dos2unix */*
    dos2unix */*/*
    dos2unix */*/*/*
fi

vagrant destroy -f && vagrant up --provider=virtualbox