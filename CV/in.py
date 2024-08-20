# Student: Alireza Mirrokni (student number: 401106617)
# Instructor: Prof. Jahangir
# Sharif University Of Technology
# Winter 2024

import numpy as np
import cv2
import matplotlib.pyplot as plt


# sharpen = 
# blur = 
# emboss = 
# edge_detection = 

kernels = [np.array([[0, 0, 0], [0, 1, 0], [0, 0, 0]]),
            np.array([[0, -1, 0], [-1, 5.6, -1], [0, -1, 0]]),
            np.array([[0.0625, 0.125, 0.0625], [0.125, 0.25, 0.125], [0.0625, 0.125, 0.0625]]),
            np.array([[-2, -1 ,0], [-1, 1, 1], [0, 1, 2]]),
            np.array([[-1, -1, -1], [-1, 8, -1], [-1, -1, -1]])]

image_name = input()

image = cv2.imread("input_images/" + image_name + ".jpg", cv2.IMREAD_COLOR)
image_size = int(min(image.shape[0], image.shape[1], 1000))
image = cv2.resize(image, (image_size, image_size))

array = np.array(image)
kernel = kernels[int(input()) - 1]

kernel_size = kernel.shape[0]
print(kernel_size)

for i in range(kernel_size):
    for j in range(kernel_size):
        print(kernel[i, j])

print(image_size)

for k in range(3):
    for i in range(image_size):
        for j in range(image_size):
            print(array[i, j, k])
        
