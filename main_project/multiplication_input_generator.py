from random import randint

f = open("C:/Users/ASUS/Desktop/assembely/Project/main_project/multiplication_input.txt", "w")

n = 30
f.write(str(n) + '\n' + str(n) + '\n')

for i in range(n):
    for j in range(n):
        f.write(str(randint(0, 1000)) + ' ')
    f.write('\n')

f.write(str(n) + '\n')

for i in range(n):
    for j in range(n):
        f.write(str(randint(0, 1000)) + ' ')
    f.write('\n')

f.close()
