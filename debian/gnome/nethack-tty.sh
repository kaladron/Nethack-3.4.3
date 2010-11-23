#!/bin/sh

set -e

HACKSTYLE=gnome

if [ -z "$NETHACKOPTIONS" ]; then
  if [ -e $HOME/.nethackrc ]; then
    NETHACKOPTIONS=$HOME/.nethackrc
    export NETHACKOPTIONS
  else
    NETHACKOPTIONS=/etc/nethack/nethackrc.tty
    export NETHACKOPTIONS
  fi
fi

HACKDIR=/usr/lib/games/nethack
export HACKDIR
HACK=$HACKDIR/nethack-$HACKSTYLE

# see if we can find the full path name of PAGER, so help files work properly
# assume that if someone sets up a special variable (HACKPAGER) for NetHack,
# it will already be in a form acceptable to NetHack
# ideas from brian@radio.astro.utoronto.ca
if test \( "xxx$PAGER" != xxx \) -a \( "xxx$HACKPAGER" = xxx \)
then

        HACKPAGER=$PAGER

#       use only the first word of the pager variable
#       this prevents problems when looking for file names with trailing
#       options, but also makes the options unavailable for later use from
#       NetHack
        for i in $HACKPAGER
        do
                HACKPAGER=$i
                break
        done

        if test ! -f $HACKPAGER
        then
                IFS=:
                for i in $PATH
                do
                        if test -f $i/$HACKPAGER
                        then
                                HACKPAGER=$i/$HACKPAGER
                                export HACKPAGER
                                break
                        fi
                done
                IFS='   '
        fi
        if test ! -f $HACKPAGER
        then
                echo Cannot find $PAGER -- unsetting PAGER.
                unset HACKPAGER
                unset PAGER
        fi
fi

cd $HACKDIR

exec $HACK "$@" $ARGS
