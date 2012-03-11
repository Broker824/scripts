#!/usr/bin/env bash
monsterwm_git_dir="/home/djura-san/programs/src_revision/git/"
monsterwm_save_dir="/home/djura-san/programs/linux/wm/monsterwm"
monsterwm_branch="monocleborders"
personal_config="/home/djura-san/tmp/monsterwm/config.h"

#start
if [ ! -d "$monsterwm_git_dir" ]; then
    echo "there was an error with monsterwm git dir (is $monsterwm_dir_git valid?)" && exit 1
  else
    cd $monsterwm_git_dir
  fi

#delete leftovers
if [ -d "monsterwm" ]; then rm -rf monsterwm/; fi

#clone repo
git clone https://github.com/c00kiemon5ter/monsterwm

#use desired branch
cd monsterwm/ && git checkout $monsterwm_branch

#copy user configs
if [ -e "$personal_config" ]; then cp -f $personal_config . && echo 'personal config copied to monsterwm'; fi

#compile it
echo && echo 'Enter root pass for installing...'
su -c 'make clean install' || exit 1

#save it for later
echo "packaging...."
if [ -e "$monsterwm_save_dir" ]; then
    cd .. && tar cjf "$monsterwm_save_dir/monsterwm-$monsterwm_branch-git$(date +%d%m%y_%H%M).tar.bz2" monsterwm/ || echo "there was an error with packaging latest monsterwm into tar.bz2 archive"
  fi
