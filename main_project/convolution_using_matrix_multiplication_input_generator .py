from random import randint

f = open("C:/Users/ASUS/Desktop/assembely/Project/main_project/convolution_using_matrix_multiplication_input.txt", "w")

k = 5
f.write(str(k) + '\n')

for i in range(k):
    for j in range(k):
        f.write(str(randint(0, 10)) + ' ')
    f.write('\n')

n = 10
f.write(str(n) + '\n')

for i in range(n):
    for j in range(n):
        f.write(str(randint(0, 1000)) + ' ')
    f.write('\n')

f.close()
