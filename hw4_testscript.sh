#!/bin/sh
echo "-------------Cleaning git-------------"
git clean -fd
echo "-------------git cleaning done !!!-------------"

git status
echo "-------------Check for untracked files---------"

ls

sleep 10

echo "-------------Running autoreconf--------------"
autoreconf -vfi > /dev/null || exit $?
echo "-------------autoreconf complete !!!-------------"

sleep 5
echo "-------------Cat configure-------------"
cat configure
echo "^^^^is configure file is good enough??????????"
echo "----------------------------------------------------"
sleep 6

echo "----------------------------------------------------"
echo "----------------------------------------------------"

echo "-------------Running configure-------------"
./configure
echo "-------------configure done !!!-------------"

sleep 5
echo "-------------make clean-------------"
make clean > /dev/null || exit $?
echo "-------------make clean done !!!-------------"

echo "-------------make-------------"
make > /dev/null || exit $?
echo "-------------make done !!!-------------"

echo "-------------make clean-------------"
make clean
echo "-------------make clean done !!!-------------"

echo "-------------make with Wall and Werror-------------"
make CFLAGS='-Wall -Werror' > /dev/null || exit $?
echo "-------------make done !!!-------------"

echo "-------------removing skey-2.0 folder-------------"
rm -rf ~/skey-2.0 > /dev/null || exit $?
echo "-------------removed skey-2.0 folder-------------"


SRCDIR="`pwd`"
OLDSRCDIR="`pwd`"
# echo $SRCDIR
SYS=`"$SRCDIR"/config.guess`
BUILDDIR="$HOME/build/$SYS"
INSTALLDIR="$HOME/install/$SYS"

echo "-Remove old $BUILDDIR and $INSTALLDIR"
rm -rf $BUILDDIR
rm -rf $INSTALLDIR

sleep 5
echo "-Create nessearry directories : $BUILDDIR and $INSTALLDIR"
mkdir -p $BUILDDIR/skey-2.0
mkdir -p $INSTALLDIR

echo "-------------Running make dist-------------"
make dist > /dev/null || exit $?
echo "-------------make dist done !!!-------------"

sleep 10
#This does not work on SOLARIS 9
echo "------------- unzipping file created from above -------------"
OSNAME=`hostname`
if [ "$OSNAME" == "a-solaris9" ] ; then
	echo "SOLARIS"
	gunzip skey-2.0.tar.gz
	tar -xvf skey-2.0.tar -C $BUILDDIR
else
	tar -xvzf skey-2.0.tar.gz -C $BUILDDIR
fi

sleep 10

echo "-cd into $BUILDDIR"
cd $BUILDDIR/skey-2.0 || exit $?

echo "-reset SRCDIR and SYS"
SRCDIR=`pwd`
SYS=`"$SRCDIR"/config.guess` #use the config.guess inside the tarball

#USED FOR SOLARIS 9
OSNAME=`hostname`
if [ "$OSNAME" == "a-solaris9" ] ; then
	echo "SOLARIS"
	export LD_LIBRARY_PATH=/opt/sfw/lib
	ldd key
fi

echo "-run $SRCDIR/configure --prefix=$INSTALLDIR"
$SRCDIR/configure  --enable-ldflags='-R/opt/sfw/lib' --enable-dynamic --disable-static --prefix=$INSTALLDIR || exit $?

echo "-----------make-----------"
make > /dev/null || exit $?
echo "-----------make install-----------"
make install > /dev/null || exit $?
echo "-----------make check-----------"
echo `pwd`
chmod 777 src/OutputTest.sh
make check || exit $?

echo "-----------run test-----------"
cd $INSTALLDIR/bin
./key -p johndoe 88 ka9q2 || exit $?

sleep 5
echo "************************************************************************"
echo "Testing start"
echo "************************************************************************"

echo "no arguments ----> Should fail"
./key
echo "************************************************************************"

sleep 2
echo "-dvl ----> Should fail"
./key -dvl
echo "************************************************************************"

sleep 2
echo "Check for help"
./key -h
echo "************************************************************************"

sleep 2
echo "Check for version"
./key -v
echo "************************************************************************"

sleep 2
echo "Check for -d and -l after key -p  -----> should fail in most cases"
./key -p france 0 india -d -l log
echo "************************************************************************"

echo "Check for -d"
./key -d -p france 0 india | tail -20
echo "************************************************************************"

echo "-l and -dd"
./key -dd -l log -p france 0 india
cat log | tail -10
echo "----------------"
cat log | wc -l
echo "----------------"
echo "2ds option"
echo "************************************************************************"
sleep 3

echo "-l and -ddd <-------> check for appending log file"
./key -ddd -l log -p france 0 india
cat log | tail -10
echo "----------------"
cat log | wc -l
echo "----------------"
echo "3ds option"
echo "************************************************************************"

sleep 3

echo "-l option with -dddd"
echo "Removing log file"
rm log
sleep 2
./key -dddd -l log -p france 0 india
echo "----------------------------------------------"
cat log | tail -10
echo "2ds option"
echo "************************************************************************"
sleep 3

echo "Should prompt for password and hide password"
./key 45 india
echo "************************************************************************"

echo "Should prompt for password and see password"
./key -e 45 india
echo "************************************************************************"

echo "Both output should be same"
./key -p france 0 india
echo "------------------------------"
./key -p france 0 india
echo "************************************************************************"

echo "Output should be different"
./key -p india 40 france
echo "------------------------------"
./key -p france 40 india
echo "************************************************************************"

sleep 10

ls -R ../
echo "Check the folder structure !!!"

sleep 10
echo "--------------- Showing man page for key-----------"
man ../man/man1/key.1 | cat
echo "-- check if the man page has new features listed --"
sleep 10

cd $OLDSRCDIR

echo "Make clean and grep for extern keyword"
make clean > /dev/null || exit $?
pwd
grep --include=\*.{c,h} --exclude=*.o -rnwI $OLDSRCDIR -e "extern" | grep -v "/misc/"
echo "---------Should not see any extern--------"
sleep 5

grep --include=\*.{c,h} --exclude=*.o -rnwI $OLDSRCDIR -e "GETENV" | grep -v "/misc/"
echo "---------Should not see any getenv--------"
sleep 5

grep --include=\*.{c,h} --exclude=*.o -rnwI $OLDSRCDIR -e "SETENV" | grep -v "/misc/"
echo "---------Should not see any setenv--------"

echo "Testing done!"

echo "Check skeysubstr - readpass function for handling -e option"
echo "Check skeysh - main function for setenv/getenv"


ls -R

echo "Check the folder structure !!!"
