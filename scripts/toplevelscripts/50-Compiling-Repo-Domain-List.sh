#!/bin/bash
## This should whitelist all domains that will be parsed

## Variables
script_dir=$(dirname $0)
source "$script_dir"/../scriptvars/staticvariables.var

####################
## Whitelist      ##
####################

SCRIPTTEXT="Processing Whitelists."
timestamp=$(echo `date`)
printf "$lightblue"    "___________________________________________________________"
echo ""
printf "$cyan"   "$SCRIPTTEXT $timestamp"
echo ""
echo "## $SCRIPTTEXT $timestamp" | tee --append $RECENTRUN &>/dev/null
bash $DELETETEMPFILE

## Quick File Check
WHATITIS="Whitelist File"
CHECKME=$LISTWHITELISTDOMAINS
timestamp=$(echo `date`)
printf "$yellow"  "Checking For $WHATITIS"
echo ""
if
ls $CHECKME &> /dev/null;
then
printf "$red"  "Removing $WHATITIS"
echo ""
rm $CHECKME
touch $CHECKME
echo "* $WHATITIS removed $timestamp" | tee --append $RECENTRUN &>/dev/null
else
printf "$cyan"  "$WHATITIS not there. Not Removing."
echo ""
touch $CHECKME
echo "* $WHATITIS not there, not removing. $timestamp" | tee --append $RECENTRUN &>/dev/null
fi

## Create The List
for f in $EVERYLISTFILEWILDCARD
do
for source in `cat $f`;
do
UPCHECK=`echo $source | awk -F/ '{print $3}'`
echo "$UPCHECK" | tee --append $LISTWHITELISTDOMAINS &>/dev/null
done
done

## Sort and Dedupe Lists
for f in $WHITELISTDOMAINSALL
do
BASEFILENAME=$(echo `basename $f | cut -f 1 -d '.'`)
source $DYNOVARS
WHATLISTTOSORT=$f
WHITESORTDEDUPE="$BASEFILENAME Domains."
timestamp=$(echo `date`)
#printf "$yellow"  "Processing $WHITESORTDEDUPE."
cat -s $WHATLISTTOSORT | sort -u | gawk '{if (++dup[$0] == 1) print $0;}' > $WWHITETEMP
HOWMANYLINES=$(echo -e "`wc -l $WWHITETEMP | cut -d " " -f 1` Lines In File")
#echo "$HOWMANYLINES"
rm $WHATLISTTOSORT
mv $WWHITETEMP $WHATLISTTOSORT
#echo ""
done

## Merge Whitelist into temp file
WHITESORTDEDUPE="Merging the Whitelists for Later."
WHATLISTSMERGE="$WHITELISTDOMAINSALL"
timestamp=$(echo `date`)
printf "$yellow"  "Processed $WHITESORTDEDUPE"
cat -s $WHATLISTSMERGE | sort -u | gawk '{if (++dup[$0] == 1) print $0;}' > $WHITELISTTEMP
HOWMANYLINES=$(echo -e "`wc -l $WHITELISTTEMP | cut -d " " -f 1` Lines In File")
echo "$HOWMANYLINES"
echo "* "$WHITESORTDEDUPE"." | tee --append $RECENTRUN &>/dev/null
echo "* $HOWMANYLINES" | tee --append $RECENTRUN &>/dev/null
echo ""
bash $DELETETEMPFILE
echo ""
echo "" | tee --append $RECENTRUN &>/dev/null
printf "$orange" "___________________________________________________________"
echo ""

#################
## Blacklist   ##
#################

SCRIPTTEXT="Processing Blacklists."
timestamp=$(echo `date`)
printf "$lightblue"    "___________________________________________________________"
echo ""
printf "$cyan"   "$SCRIPTTEXT $timestamp"
echo ""
echo "## $SCRIPTTEXT $timestamp" | tee --append $RECENTRUN &>/dev/null
bash $DELETETEMPFILE
WHATITIS="Blacklist File"
CHECKME=$LISTWHITELISTDOMAINS
timestamp=$(echo `date`)
printf "$yellow"  "Checking For $WHATITIS"
echo ""

## Quick File Check
if
ls $CHECKME &> /dev/null;
then
printf "$red"  "Removing $WHATITIS"
echo ""
rm $CHECKME
touch $CHECKME
echo "* $WHATITIS removed $timestamp" | tee --append $RECENTRUN &>/dev/null
else
printf "$cyan"  "$WHATITIS not there. Not Removing."
echo ""
touch $CHECKME
echo "* $WHATITIS not there, not removing. $timestamp" | tee --append $RECENTRUN &>/dev/null
fi

## Sort And Dedupe Lists
for f in $BLACKLISTDOMAINSALL
do
BASEFILENAME=$(echo `basename $f | cut -f 1 -d '.'`)
source $DYNOVARS
WHATLISTTOSORT=$f
BLACKSORTDEDUPE="$BASEFILENAME Domains."
timestamp=$(echo `date`)
#printf "$yellow"  "Processing $BLACKSORTDEDUPE."
cat -s $WHATLISTTOSORT | sort -u | gawk '{if (++dup[$0] == 1) print $0;}' > $BBLACKTEMP
HOWMANYLINES=$(echo -e "`wc -l $BBLACKTEMP | cut -d " " -f 1` Lines In File")
#echo "$HOWMANYLINES"
rm $WHATLISTTOSORT
mv $BBLACKTEMP $WHATLISTTOSORT
#echo ""
done

## Merge Lists
BLACKSORTDEDUPE="Merging the Blacklists for Later."
WHATLISTSMERGE="$BLACKLISTDOMAINSALL"
timestamp=$(echo `date`)
printf "$yellow"  "Processed $BLACKSORTDEDUPE"
cat -s $WHATLISTSMERGE | sort -u | gawk '{if (++dup[$0] == 1) print $0;}' > $BLACKLISTTEMP
HOWMANYLINES=$(echo -e "`wc -l $BLACKLISTTEMP | cut -d " " -f 1` Lines In File")
echo "$HOWMANYLINES"
echo "* "$BLACKSORTDEDUPE"." | tee --append $RECENTRUN &>/dev/null
echo "* $HOWMANYLINES" | tee --append $RECENTRUN &>/dev/null
echo ""
bash $DELETETEMPFILE
echo ""
echo "" | tee --append $RECENTRUN &>/dev/null
printf "$orange" "___________________________________________________________"
echo ""

####################
## pihole -w      ##
####################

## Whitelist the domains
#for source in `cat $WHITELISTTEMP`;
#do
#pihole -w $source &>/dev/null
#done
