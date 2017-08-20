#!/bin/bash
## This is the central script that ties the others together

## Variables
script_dir=$(dirname $0)
SCRIPTVARSDIR="$script_dir"/scriptvars/
STATICVARS="$SCRIPTVARSDIR"staticvariables.var
if
[[ -f $STATICVARS ]]
then
source $STATICVARS
else
echo "Static Vars File Missing, Exiting."
exit
fi
if
[[ -f $SUBMAINVAR ]]
then
source $SUBMAINVAR
else
echo "Sub Main Vars File Missing, Exiting."
exit
fi

## Logo
if
[[ -f $SUBMAINVAR ]]
then
bash $AVATARSCRIPT
else
echo "Deathbybandaid Logo Missing."
fi

## Start File Loop
## For .sh files In The mainscripts Directory
for f in $ALLTOPLEVELSCRIPTS
do

# Dynamic Variables
BASEFILENAME=$(echo `basename $f | cut -f 1 -d '.'`)
if
[[ -f $DYNOVARS ]]
then
source $DYNOVARS
else
echo "Dynamic Vars File Missing, Exiting."
exit
fi

## Loop Variables
SCRIPTTEXT=""$BNAMEPRETTYSCRIPTTEXT"."
timestamp=$(echo `date`)

printf "$blue"    "$DIVIDERBAR"
echo ""
printf "$cyan"   "$SCRIPTTEXT $timestamp"

## Log Section
echo "## $SCRIPTTEXT $timestamp" | tee --append $RECENTRUN &>/dev/null

## Clear Temp Before
if
[[ -f $DELETETEMPFILE ]]
then
bash $DELETETEMPFILE
else
echo "Error Deleting Temp Files."
exit
fi

## Run Script
bash $f

## Clear Temp After
if
[[ -f $DELETETEMPFILE ]]
then
bash $DELETETEMPFILE
else
echo "Error Deleting Temp Files."
exit
fi

echo "$TAGTHEREPOLOG" | sudo tee --append $RECENTRUN &>/dev/null
echo "" | sudo tee --append $RECENTRUN
printf "$magenta" "$DIVIDERBAR"
echo ""

## End Of Loop
done
