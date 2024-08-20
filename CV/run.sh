#!/bin/bash
nasm -f elf64 asm_io.asm && 
gcc -m64 -no-pie -std=c17 -c driver.c
nasm -f elf64 $1.asm &&
gcc -m64 -no-pie -std=c17 -o $1 driver.c $1.o asm_io.o &&

clear
echo "Welcome to CV using assembly"
echo "Press enter buttom to continue..."
read key
clear

echo "Please enter the image file name that you want to proccess (without file format). make sure that you have transfered the image to the input_images folder."

flag=0 
while [ $flag -eq 0 ];
do
    read file_name
    file_path="input_images/"$file_name".jpg"
    if  ! test -f $file_path; 
    then
        echo "File does not exist."
    else
        flag=1
    fi
done  
echo "$file_name" > "input.txt"
echo "$file_name" > "output1.txt"
clear

echo -e 'Please enter the number of your desired kernel:\n1.Identity\n2.Sharpen\n3.Blur\n4.Emboss\n5.Edge_detection'

flag=0
while [ $flag -eq 0 ];
do
    read kernel_number
    if [[ "$kernel_number" =~ ^[0-9]+$ ]]
    then
        if  [ $kernel_number -lt 1 ] || [ $kernel_number -gt 5 ]; 
        then
            echo "Invalid number. Please enter a number between 1 and 5:"
        else
            flag=1
        fi
    else
        echo "Invalid number. Please enter a number between 1 and 5:"
    fi
   
done  
echo "$kernel_number" >> "input.txt"
echo "$kernel_number" >> "output1.txt" &&

python3 in.py < "input.txt"  > "output.txt"
./template < "output.txt" >> "output1.txt"
python3 out.py < "output1.txt" &&
rm input.txt output.txt output1.txt &&

./$1


