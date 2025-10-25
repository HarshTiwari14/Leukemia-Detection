#!/usr/bin/env python
# coding: utf-8

import cv2
import numpy as np

img = cv2.imread('F2.jpg')
img = cv2.resize(img, (300, 200))
img_display = img.copy()

img_gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
img_blur = cv2.GaussianBlur(img_gray, (7, 7), 0)

ret, thresh = cv2.threshold(img_blur, 140, 255, cv2.THRESH_BINARY_INV)
contours, hierarchy = cv2.findContours(thresh, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

min_area = 50
cell_contours = [c for c in contours if cv2.contourArea(c) > min_area]
total_cells = len(cell_contours)

cancer_contours = []
for c in cell_contours:
    area = cv2.contourArea(c)
    if 300 < area < 2000:
        cancer_contours.append(c)

cancer_cells = len(cancer_contours)

cv2.drawContours(img_display, cell_contours, -1, (255, 255, 0), 1)
cv2.drawContours(img_display, cancer_contours, -1, (0, 0, 255), 2)

if total_cells > 0:
    cancer_percent = (cancer_cells / total_cells) * 100
else:
    cancer_percent = 0

if cancer_percent < 0.8:
    status = "Healthy. No Problem."
elif 0.5 < cancer_percent < 1:
    status = "High myeloid cell concentration."
elif 1 < cancer_percent < 8:
    status = "Initial Stage Leukemia."
else:
    status = "Advanced Stage Leukemia."

print("------------------------------------")
print(f"Total Cells Detected: {total_cells}")
print(f"Cancer (Myeloid) Cells Detected: {cancer_cells}")
print(f"Myeloid Cell Percentage: {cancer_percent:.2f}%")
print(f"Diagnosis: {status}")
print("------------------------------------")

cv2.putText(img_display, f'Total: {total_cells}', (10, 20), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255,255,255), 2)
cv2.putText(img_display, f'Cancer: {cancer_cells}', (10, 45), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0,0,255), 2)
cv2.putText(img_display, f'{status}', (10, 70), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255,255,0), 2)

cv2.imshow('Original Image', img)
cv2.imshow('Thresholded Image', thresh)
cv2.imshow('Detected Cells', img_display)

cv2.waitKey(0)
cv2.destroyAllWindows()
