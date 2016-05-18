#!/bin/sh
echo "-------------Cleaning git-------------"
git clean -fd
echo "-------------git cleaning done !!!-------------"

echo "-------------Running autoreconf--------------"
autoreconf -i > /dev/null || exit $?
echo "-------------autoreconf complete !!!-------------"

echo "-------------Cat configure-------------"
cat configure
echo "----------------------------------------------------"

echo "----------------------------------------------------"
echo "----------------------------------------------------"

echo "-------------Running configure-------------"
./configure
echo "-------------configure done !!!-------------"

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
make CFLAGS='-Wall -Werror'
make CFLAGS='-Wall -Werror' > /dev/null || exit $?
echo "-------------make done !!!-------------"

echo "-------------removing skey-2.0 folder-------------"
rm -rf ~/skey-2.0 > /dev/null || exit $?
echo "-------------removed skey-2.0 folder-------------"


# #!/bin/sh
SRCDIR="`pwd`"
# echo $SRCDIR
SYS=`"$SRCDIR"/config.guess`
BUILDDIR="$HOME/build/$SYS"
INSTALLDIR="$HOME/install/$SYS"

echo "-Remove old $BUILDDIR and $INSTALLDIR"
rm -rf $BUILDDIR
rm -rf $INSTALLDIR

echo "-Create nessearry directories : $BUILDDIR and $INSTALLDIR"
mkdir -p $BUILDDIR/skey-2.0
mkdir -p $INSTALLDIR

echo "-------------Running make dist-------------"
make dist
echo "-------------make dist done !!!-------------"

sleep 10
#This does not work on SOLARIS 9
echo "-unzip"
tar -xvzf skey-2.0.tar.gz -C $BUILDDIR

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
./key -d -p france 0 india
echo "************************************************************************"

echo "-l and -dd"
./key -dd -l log -p france 0 india
cat log
echo "----------------"
cat log | wc -l
echo "----------------"
echo "************************************************************************"

echo "-l and -ddd <-------> check for appending log file"
./key -ddd -l log -p france 0 india
cat log
echo "----------------"
cat log | wc -l
echo "----------------"
echo "************************************************************************"

echo "-l option with -dddd"
echo "Removing log file"
rm log
./key -dddd -l log -p france 0 india
echo "----------------------------------------------"
cat log
echo "************************************************************************"

echo "Should prompt for password and hide password"
./key 45 india
echo "************************************************************************"

echo "Should prompt for password and see password"
./key -e 45 india
echo "************************************************************************"

echo "Both output should be same"
./key -d -p france 0 india
echo "------------------------------"
./key -d -p france 0 india
echo "************************************************************************"

echo "Output should be different"
./key -p india 40 france
echo "------------------------------"
./key -p france 40 india
echo "************************************************************************"

echo "Testing done!"
