#!/bin/sh
make clean
rm cipher
rm *.o
make
echo "*****************************************"
echo "Testing start"
echo "*****************************************"

echo "Options checking"
echo "Error options"
echo "*****************************************"
./cipher -a -b -c
echo "*****************************************"
./cipher -abid
echo "*****************************************"
./cipher -e
echo "*****************************************"
./cipher -e -e
echo "*****************************************"
./cipher -d
echo "*****************************************"
./cipher -d -d
echo "*****************************************"
./cipher -p
echo "*****************************************"
./cipher -e -p
echo "*****************************************"
./cipher -d -p
echo "*****************************************"
./cipher -e -d
echo "*****************************************"
./cipher -ed
echo "*****************************************"
./cipher -e f1
echo "*****************************************"
./cipher -d f1
echo "*****************************************"
./cipher -ve
echo "*****************************************"
./cipher -vd
echo "*****************************************"
./cipher f1 f2
echo "*****************************************"
./cipher -p face f1
echo "*****************************************"
echo "Success options"
echo "*****************************************"
./cipher -h
echo "*****************************************"
./cipher -v
echo "*****************************************"
./cipher -hv
echo "*****************************************"
sleep 3
echo "is it prompting for password <diff file>"
./cipher -e f1 f2
echo "*****************************************"
echo "is it prompting for password <same file>"
./cipher -e f1 f1
echo "*****************************************"
echo "Basic functionality"
echo "*****************************************"
echo "File Permission / Access check"
touch f1
touch f2
chmod 000 f1
./cipher -e -p face f1 f2
yes | rm f2
yes | rm f1
echo "*****************************************"

echo "Case 1 - Regular ./cipher -e -p <> <f1> <f2>"
./cipher -e -p face /home/hraman/testing/hw1-hraman/bf_cfb64.c e
./cipher -d -p face e d
echo "Diff :"
echo "-----------------------------------------"
diff d /home/hraman/testing/hw1-hraman/bf_cfb64.c
echo "-----------------------------------------"
sleep 3
echo "*****************************************"
echo "Case 2 - stdin/stdout ./cipher -e -p <> - - < f1 > f2"
./cipher -e -p face - - < /home/hraman/testing/hw1-hraman/bf_cfb64.c > e
./cipher -d -p face - < e d
echo "Diff :"
echo "-----------------------------------------"
diff d /home/hraman/testing/hw1-hraman/bf_cfb64.c
echo "-----------------------------------------"
sleep 3
echo "*****************************************"
echo "Case 3 - stdin/stdout cat /home/hraman/testing/hw1-hraman/bf_cfb64.c | ./cipher -e -p face - d"
cat /home/hraman/testing/hw1-hraman/bf_cfb64.c | ./cipher -e -p face - e
echo "-----------------------------------------"
echo "Display decrypted file"
echo "-----------------------------------------"
./cipher -d -p face - - < e
./cipher -d -p face - < e d
echo "Diff :"
echo "-----------------------------------------"
diff d /home/hraman/testing/hw1-hraman/bf_cfb64.c
echo "-----------------------------------------"
sleep 3
echo "*****************************************"
echo "Case 4 - Test for empty file"
echo "-----------------------------------------"
echo "should not throw error"
touch t
./cipher -e -p face t e
./cipher -d -p face t d
echo "displaying empty file"
echo "-----------------------------------------"
cat t
echo "-----------------------------------------"
rm t
echo "*****************************************"
echo "Case 5 - Test for directory"
echo "should throw error"
mkdir tmpdir
./cipher -e -p face tmpdir e
./cipher -d -p face tmpdir d
rm -rf tmpdir
echo "*****************************************"
echo "Case 6 -Test for non existent file"
echo "-----------------------------------------"
echo "should throw error"
./cipher -e -p face t e
echo "*****************************************"
echo "Case 7 - Test for same file name"
echo "-----------------------------------------"
touch t
./cipher -e -p face t t
echo "Displaying t"
echo "-----------------------------------------"
cat t
echo "-----------------------------------------"
rm t
echo "*****************************************"
echo "Case 8 - Double encryption"
echo "Result - empty diff"
./cipher -e -p face /home/hraman/testing/hw1-hraman/bf_cfb64.c e1
./cipher -e -p face e1 e2
./cipher -d -p face e2 d2
./cipher -d -p face d2 d1
echo "Diff : "
echo "-----------------------------------------"
diff /home/hraman/testing/hw1-hraman/bf_cfb64.c d1
echo "-----------------------------------------"

echo "*****************************************"
echo "Case  9a - Test for password prompt"
echo "Result - Should prompt for password"
./cipher -e /home/hraman/testing/hw1-hraman/bf_cfb64.c e
echo "encryption done"
./cipher -d e d
echo "decryption done"
echo "diff: "
echo "-----------------------------------------"
diff d /home/hraman/testing/hw1-hraman/bf_cfb64.c
echo "-----------------------------------------"
echo "*****************************************"
echo "Case  9b - Test for password prompt"
echo "Result - Should prompt for password"
echo "Give different password"
./cipher -e /home/hraman/testing/hw1-hraman/bf_cfb64.c e
echo "encryption done"
./cipher -d e d
echo "decryption done"
echo "diff: "
echo "-----------------------------------------"
diff d /home/hraman/testing/hw1-hraman/bf_cfb64.c
echo "-----------------------------------------"
echo "*****************************************"
echo "Extra credit testing"
echo "*****************************************"
echo "-s option"
echo "-p face given with -s"
echo "should fail"
./cipher -es -p face /home/hraman/testing/hw1-hraman/bf_cfb64.c e
echo "-p not given with -s"
echo "should pass"
./cipher -es /home/hraman/testing/hw1-hraman/bf_cfb64.c e
echo "encryption done"
./cipher -ds e d
echo "decryption done"
echo "diff :"
echo "-----------------------------------------"
diff d /home/hraman/testing/hw1-hraman/bf_cfb64.c
echo "-----------------------------------------"
echo "*****************************************"
echo "Check for m flag both in e & d"
./cipher -me /home/hraman/testing/hw1-hraman/bf_cfb64.c e
./cipher -md e d
echo "diff :"
echo "-----------------------------------------"
diff d /home/hraman/testing/hw1-hraman/bf_cfb64.c
echo "-----------------------------------------"
echo "Check for m flag only in e"
./cipher -me /home/hraman/testing/hw1-hraman/bf_cfb64.c e
./cipher -d e d
echo "diff :"
echo "-----------------------------------------"
diff d /home/hraman/testing/hw1-hraman/bf_cfb64.c
echo "-----------------------------------------"
echo "Check for m flag only in d"
./cipher -e /home/hraman/testing/hw1-hraman/bf_cfb64.c e
./cipher -md e d
echo "diff :"
echo "-----------------------------------------"
diff d /home/hraman/testing/hw1-hraman/bf_cfb64.c
echo "-----------------------------------------"
echo "*****************************************"
echo "Check for -E flag"
echo "should fail"
./cipher -Ee -p face /home/hraman/testing/hw1-hraman/bf_cfb64.c e
echo "should print random * pass"
./cipher -Ee /home/hraman/testing/hw1-hraman/bf_cfb64.c e
./cipher -Ed e d
echo "diff :"
echo "-----------------------------------------"
diff d /home/hraman/testing/hw1-hraman/bf_cfb64.c
echo "-----------------------------------------"

echo "*****************************************"
echo "Case  10 - Test for password prompt and take input from terminal"
./cipher -e - -
echo "*****************************************"
echo "Testing done!"
