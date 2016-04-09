#!/bin/bash

echo "*****************************************"

echo "Check git submission"
echo "find (exclude *.c,*.h,Makefile,README)"
echo "Should not find any files"
find . -type f ! -path "./.git/*" -a ! -name '*.c' -a ! -name '*.h' -a ! -iname 'Makefile' -a ! -iname 'readme' -a ! -name '.DS_Store' -a ! -name 'hw2-case.sh'
echo "Check git finish"
echo "*****************************************"
echo ""

echo "Check Makefile Target"
cd parts-1+2
echo "----------------------------------------"
echo ""

echo "Check clean: Should not print anything"
make clean 2>&1 | grep "No rule to make target"
echo "Check clean finish"
echo "----------------------------------------"

echo ""
echo "Check prog-XX-gcc"
for i in {1..9}
do
    make prog-0$i-gcc
done
for i in {10..21}
do
    make prog-$i-gcc
done
echo "Check prog-XX-gcc finish"
echo "----------------------------------------"
echo ""

echo "Check run-XX-gcc"
for i in {1..9}
do
    make run-0$i-gcc
    echo "++++++++++++++++++++++++++++++"
    echo ""
done
for i in {10..21}
do
    make run-$i-gcc
    echo "++++++++++++++++++++++++++++++"
    echo ""
done
echo "Check run-XX-gcc finish"
echo "----------------------------------------"
echo ""

make clean 2>&1 | grep "No rule to make target"
echo "Check all-gcc"
make all-gcc
echo "Check all-gcc finish"
echo "*****************************************"
echo ""

cd ../part-3/

echo "Check xmalloc"
echo '#include "xmalloc.h"' > case1.c
echo 'int main() {xfree((void*)55);}' >> case1.c

echo '#include "xmalloc.h"' > case2.c
echo 'int main() {void *ptr = xmalloc(10);xfree(ptr + 1);}' >> case2.c

echo '#include "xmalloc.h"' > case3.c
echo 'int main() {void *ptr = xmalloc(10);xfree(ptr);xfree(ptr);}' >> case3.c

echo '#include "xmalloc.h"' > case4.c
echo 'int main() {void *ptr = xmalloc(10);}' >> case4.c
gcc -Wall -Werror -c xmalloc.c -o xmalloc.o
gcc case1.c xmalloc.o -o case1
gcc case2.c xmalloc.o -o case2
gcc case3.c xmalloc.o -o case3
gcc case4.c xmalloc.o -o case4

echo "Check Invalid free"
./case1
echo "----------------------------------------"
echo ""

echo "Check free in the middle"
./case2
echo "----------------------------------------"
echo ""

echo "Check double free"
./case3
echo "----------------------------------------"
echo ""

echo "Check memory leak"
./case4
echo "----------------------------------------"
echo ""

echo "Check xmalloc finish"
echo "*****************************************"
echo ""
