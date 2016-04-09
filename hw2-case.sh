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

echo "Check all-gcc"
make all-gcc
echo "Check all-gcc finish"
echo "*****************************************"
echo ""

echo "Check prog-XX-gcc"
make clean 2>&1 | grep "No rule to make target"
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

echo "Inspect src code, then check target run-XX-gcc"
for i in {1..2}
do
    echo $i
    echo "grep 'malloc'"
    echo "Should not find"
#    grep 'malloc' prog-0$i.c -n
#    echo "gerp '\['"
#    echo "Verify index"
#    grep '\[' prog-0$i.c -n -B 2
    echo ""

    make run-0$i-gcc
    echo "++++++++++++++++++++++++++++++"
    echo ""
done

for i in {3..4}
do
    echo $i
    echo "grep 'malloc'"
    echo "Should find"
    grep 'malloc' prog-0$i.c -n
#    echo "gerp '\['"
#    echo "Verify index"
#    grep '\[' prog-0$i.c -n -B 2
    echo ""

    make run-0$i-gcc
    echo "++++++++++++++++++++++++++++++"
    echo ""
done

for i in {5..5}
do
    echo $i
    echo "grep 'NULL'"
    echo "Should find"
    grep 'NULL' prog-0$i.c -n
    echo "grep 'free'"
    echo "Should find"
    grep 'free' prog-0$i.c -n
    echo ""

    make run-0$i-gcc
    echo "++++++++++++++++++++++++++++++"
    echo ""
done

for i in {6..7}
do
    echo $i
    echo "grep 'malloc'"
    echo "Should not find"
    grep 'malloc' prog-0$i.c -n
    echo "grep 'free'"
    echo "Should find"
    grep 'free' prog-0$i.c -n
    echo "grep '"' "
    echo "7 Should find, 6 don't care"
    grep '"' prog-0$i.c -n
    echo ""

    make run-0$i-gcc
    echo "++++++++++++++++++++++++++++++"
    echo ""
done

for i in {8..8}
do
    echo $i
    echo "grep 'free'"
    echo "Should find twice"
    grep -E '[^"]free\(.*\)' prog-0$i.c -n
    echo ""

    make run-0$i-gcc
    echo "++++++++++++++++++++++++++++++"
    echo ""
done

for i in {9..9}
do
    echo $i
    echo "grep 'malloc'"
    echo "Should not find"
    grep 'malloc' prog-0$i.c -n
    echo "grep 'realloc'"
    echo "Should find"
    grep 'realloc' prog-0$i.c -n
    echo ""

    make run-0$i-gcc
    echo "++++++++++++++++++++++++++++++"
    echo ""
done

for i in {10..10}
do
    echo $i
    echo "grep 'malloc'"
    echo "Should find"
    grep 'malloc' prog-$i.c -n
    echo "grep 'free'"
    echo "Should find"
    grep -E '[^"]free\(.*\)' prog-$i.c -n
    echo "grep '*'"
    echo "Should find after free"
    grep '*' prog-$i.c -n
    echo "grep '\['"
    echo "Should find after free"
    grep '\[' prog-$i.c -n
    echo ""

    make run-$i-gcc
    echo "++++++++++++++++++++++++++++++"
    echo ""
done

for i in {11..11}
do
    echo $i
    echo "grep 'NULL/0'"
    echo "Should find"
    grep -E 'NULL|0' prog-$i.c -n
    echo "grep '*'"
    echo "Should find after NULL"
    grep '*' prog-$i.c -n
    echo ""

    make run-$i-gcc
    echo "++++++++++++++++++++++++++++++"
    echo ""
done

for i in {12..12}
do
    echo $i
    echo "grep '='"
    echo "Should find small num on rhs"
    grep '=' prog-$i.c -n
    echo "grep '*'"
    echo "Should find after ="
    grep '*' prog-$i.c -n
    echo ""

    make run-$i-gcc
    echo "++++++++++++++++++++++++++++++"
    echo ""
done

for i in {14..14}
do
    echo $i
    echo "grep 'memcpy'"
    echo "Should find"
    grep 'malloc' prog-$i.c -n -B 2 -A 2
    echo ""

    make run-$i-gcc
    echo "++++++++++++++++++++++++++++++"
    echo ""
done

for i in {18..20}
do
    echo $i
    echo "grep 'memcpy'"
    echo "Should find, null as one param"
    echo "for 20, 3rd param == 0"
    grep '=' prog-$i.c -n
    echo "grep 'memcpy'"
    echo ""

    make run-$i-gcc
    echo "++++++++++++++++++++++++++++++"
    echo ""
done

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "manual check starts"

for i in {13..13}
do
    echo $i
    echo "ptr not aligned"
    cat prog-$i.c
    echo ""
    echo ""
    echo ""

    make run-$i-gcc
    echo "++++++++++++++++++++++++++++++"
    echo ""
done

for i in {15..15}
do
    echo $i
    echo "compare ptr of different type"
    cat prog-$i.c
    echo ""
    echo ""
    echo ""
    echo ""

    make run-$i-gcc
    echo "++++++++++++++++++++++++++++++"
    echo ""
done

for i in {16..16}
do
    echo $i
    echo "illegal ptr created by ptr arithmatic"
    cat prog-$i.c
    echo ""
    echo ""
    echo ""
    echo ""

    make run-$i-gcc
    echo "++++++++++++++++++++++++++++++"
    echo ""
done

for i in {17..17}
do
    echo $i
    echo "read uninitialized mem"
    cat prog-$i.c
    echo ""
    echo ""
    echo ""
    echo ""

    make run-$i-gcc
    echo "++++++++++++++++++++++++++++++"
    echo ""
done

for i in {21..21}
do
    echo $i
    echo "read popped stack obj"
    cat prog-$i.c
    echo ""
    echo ""
    echo ""
    echo ""

    make run-$i-gcc
    echo "++++++++++++++++++++++++++++++"
    echo ""
done

echo "Check run-XX-gcc finish"
echo "----------------------------------------"
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
