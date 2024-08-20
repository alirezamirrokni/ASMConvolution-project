# Student: Alireza Mirrokni (student number: 401106617)
# Instructor: Prof. Jahangir
# Sharif University Of Technology
# Winter 2024*65

import numpy as np
import cv2
import matplotlib.pyplot as plt

kernel_names = ["identity", "sharpen", "blur", "emboss", "edge_detection"]

image_name = input()
kernel_name = kernel_names[int(input()) - 1]

image = cv2.imread("input_images/" + image_name + ".jpg", cv2.IMREAD_COLOR)
image_size = int(min(image.shape[0], image.shape[1], 1000))
image = cv2.resize(image, (image_size, image_size))
kernel_size = 3

array = np.array([[[0.0 for j in range(image_size)] for i in range(image_size)] for k in range(3)], dtype = np.float32)
array = np.reshape(array, (image_size, image_size, 3))

for k in range(3):
    for i in range(image_size):
        array[i, :, k] = np.array(list(float(num) for num in input().split()))
    
cv2.imwrite('output_images/' + image_name + '_' + kernel_name + '.jpg', array)
cv2.imshow("before", image)
cv2.imshow("after", cv2.imread('output_images/' + image_name + '_' + kernel_name + '.jpg', cv2.IMREAD_COLOR))
cv2.waitKey(0) 