#!/bin/bash
#
# Copyright (C) 2008 Eric Leblond
#
# Version 0.4
#
# subversion-prompt : Subversion aware bash prompt.
# To use it, add something like that to your .bashrc:
   SVNP_HUGE_REPO_EXCLUDE_PATH="nufw-svn$|/tags$|/branches$"
#    . ~/bin/subversion-prompt
#    # set a fancy prompt
   PS1='\u@\h:\w$(__svn_stat)\$ '
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#
# Changelog :
#  2008-05-09: v0.4
# Option to check distant status
# Prefix env var by SVNP
#  2008-05-08: v0.3, Use environnement variable
#  2008-05-08: v0.2, Add HUGE_REPO options
#  2008-05-08: v0.1, initial release
#

# Set environnement variable CHECK_DISTANT_REPO to
# display if an updated is needed

# List of path to exclude from recursive status
# Explanation of following regexp:
# Exclude all directories under inl-svn, the nufw-svn directory, and
# all directories ending by /tags par /branches
# You can set it as environnement variable
if [ ! $SVNP_HUGE_REPO_EXCLUDE_PATH ]; then
  SVNP_HUGE_REPO_EXCLUDE_PATH="/tags$|/branches$"
fi

# Set SVNP_HAVE_HUGE_REPO if you have huge repository
# This will disable recursion when searching status
# and speed things a lot (but feature is less interessant).
# You can also look at the HUGE_REPO_EXCLUDE_PATH option

__svn_rev ()
{
  LANG='C' svn info 2>/dev/null | awk '/Revision:/ {print $2; }'
}

__svn_last_changed ()
{
  LANG='C' svn info 2>/dev/null | awk '/Last Changed Rev:/ { print $4;}'
}


__svn_clean ()
{
  if [ $SVNP_HAVE_HUGE_REPO ]; then
    HUGE_REPO=" -N ";
  else
    pwd | egrep -q $SVNP_HUGE_REPO_EXCLUDE_PATH && HUGE_REPO=" -N "
  fi
  STATE=$(LANG='C' svn $HUGE_REPO status -q 2>/dev/null | grep "^[MA]" | wc -l)
  if [ $STATE != 0 ]; then
    echo "$2"
  else
    echo "$1"
  fi
}
__svn_remote_clean ()
{
  if [ $SVNP_HAVE_HUGE_REPO ]; then
    HUGE_REPO=" -N ";
  else
    pwd | egrep -q $SVNP_HUGE_REPO_EXCLUDE_PATH && HUGE_REPO=" -N "
  fi
  STATE=$(LANG='C' svn $HUGE_REPO status -u -q 2>/dev/null | egrep  " *\*" | wc -l)
  if [ $STATE != 0 ]; then
    echo "$2"
  else
    echo "$1"
  fi
}

__svn_stat ()
{
  [ -d .svn ] || return
  REV=$(__svn_rev)
  if [ $REV ]; then
    if [ $SVNP_CHECK_DISTANT_REPO ]; then
      REMOTE_STATUS=$(__svn_remote_clean "" "*")
    fi
    LOCAL_STATUS=$(__svn_clean "" "*")
    echo [$REMOTE_STATUS$REV$LOCAL_STATUS]
  fi
}
