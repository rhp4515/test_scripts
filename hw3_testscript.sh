#!/bin/sh
echo "************************************************************************"
echo "Testing start"
echo "************************************************************************"

echo "no arguments ----> Should fail"
./key
echo "************************************************************************"

echo "-dvl ----> Should fail"
./key -dvl
echo "************************************************************************"

echo "Check for help"
./key -h
echo "************************************************************************"

echo "Check for version"
./key -v
echo "************************************************************************"

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

echo "Should prompt for password"
./key -d 45 india
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