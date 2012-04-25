#!/usr/bin/env bash
monsterwm_git_url="https://github.com/c00kiemon5ter/monsterwm"
monsterwm_git_dir="/home/djura-san/programs/src_revision/git/"
monsterwm_save_dir="/home/djura-san/programs/linux/wm/monsterwm"
monsterwm_branch="monocleborders"
monsterwm_merge_branch=""
personal_config="/home/djura-san/projects/code/dotfiles-and-configs/monsterwm/src/config.h"

#start
if [ ! -d "$monsterwm_git_dir" ]; then
    echo "there was an error with monsterwm git dir (is $monsterwm_dir_git valid?)" && exit 1
  else
    cd $monsterwm_git_dir
  fi

#delete leftovers
if [ -d "monsterwm" ]; then rm -rf monsterwm/; fi

#clone repo and use desired branch
#long one:  git clone $monsterwm_git_url && cd monsterwm/ && git checkout $monsterwm_branch
git clone -b $monsterwm_branch "$monsterwm_git_url" && cd monsterwm/

#copy user configs
if [ -e "$personal_config" ]; then cp -f "$personal_config" . && echo 'personal config copied to monsterwm'; fi

#compile it
echo && echo -n 'Root '; su -c 'make clean install' || exit 1

#save it for later but exclude .git files (and other dotfiles)
echo "packaging...."
if [ -e "$monsterwm_save_dir" ]; then
    cd .. && tar cjf "$monsterwm_save_dir/monsterwm-$monsterwm_branch-git$(date +%d%m%Y_%H%M).tar.bz2" monsterwm/ --exclude '.*' || echo "there was an error with packaging latest monsterwm ($monsterwm_branch branch) into tar.bz2 archive"
  fi



# try
#git checkout moveresize
#git checkout initlayouts
#git merge moveresize
#git merge initlayouts
