#!/usr/bin/env python
# coding: utf-8

import cv2
import numpy as np

img = cv2.imread('F2.jpg')
img = cv2.resize(img, (300, 200))
img_display = img.copy()

img_lab = cv2.cvtColor(img, cv2.COLOR_BGR2LAB)
l, a, b = cv2.split(img_lab)
clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8,8))
cl = clahe.apply(l)
merged = cv2.merge((cl, a, b))
img_enh = cv2.cvtColor(merged, cv2.COLOR_LAB2BGR)

gray = cv2.cvtColor(img_enh, cv2.COLOR_BGR2GRAY)
blur = cv2.GaussianBlur(gray, (7,7), 0)
thresh = cv2.adaptiveThreshold(blur, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY_INV, 35, 5)
kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (3,3))
morph = cv2.morphologyEx(thresh, cv2.MORPH_OPEN, kernel, iterations=2)
morph = cv2.morphologyEx(morph, cv2.MORPH_CLOSE, kernel, iterations=2)

contours, _ = cv2.findContours(morph, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
min_area = 50
cell_contours = [c for c in contours if cv2.contourArea(c) > min_area]
total_cells = len(cell_contours)

cancer_contours = []
for c in cell_contours:
    area = cv2.contourArea(c)
    perimeter = cv2.arcLength(c, True)
    if perimeter == 0:
        continue
    circularity = 4 * np.pi * (area / (perimeter * perimeter))
    if 300 < area < 2000 and circularity < 0.85:
        cancer_contours.append(c)

cancer_cells = len(cancer_contours)

if total_cells > 0:
    cancer_percent = (cancer_cells / total_cells) * 100
else:
    cancer_percent = 0

if cancer_percent < 0.5:
    status = "Healthy — No abnormality."
elif cancer_percent < 2:
    status = "High myeloid concentration."
elif cancer_percent < 8:
    status = "Initial Stage Leukemia."
else:
    status = "Advanced Stage Leukemia."

cv2.drawContours(img_display, cell_contours, -1, (0,255,255), 1)
cv2.drawContours(img_display, cancer_contours, -1, (0,0,255), 2)

cv2.putText(img_display, f'Total: {total_cells}', (10, 20), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255,255,255), 2)
cv2.putText(img_display, f'Cancer: {cancer_cells}', (10, 45), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0,0,255), 2)
cv2.putText(img_display, f'{status}', (10, 70), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0,255,255), 2)

print("------------------------------------")
print(f"Total Cells Detected: {total_cells}")
print(f"Cancer (Myeloid) Cells Detected: {cancer_cells}")
print(f"Myeloid Cell Percentage: {cancer_percent:.2f}%")
print(f"Diagnosis: {status}")
print("------------------------------------")

cv2.imshow('Enhanced Image', img_enh)
cv2.imshow('Thresholded', morph)
cv2.imshow('Detected Cells', img_display)
cv2.waitKey(0)
cv2.destroyAllWindows()
