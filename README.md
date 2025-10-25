# Leukemia Detection using Image Processing

This project provides a computational approach to detect leukemia from blood smear images. It includes implementations in both Python and MATLAB, which use image processing techniques to segment and analyze white blood cells to identify cancerous characteristics.

***

## 📂 Repository Contents

* `leukemia detect.py`: The primary Python script for leukemia detection.
* `cancer_detect.m`: The MATLAB script for leukemia detection.
* `F1.jpg`: Sample blood smear image for analysis.
* `F2.jpg`: Second sample blood smear image for analysis.
* `venv/`: A folder for the Python virtual environment and its dependencies.

***

## 🚀 How to Run

You can run the detection algorithm using either the Python script or the MATLAB script.

### Python Instructions

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/HarshTiwari14/Leukemia-Detection.git](https://github.com/HarshTiwari14/Leukemia-Detection.git)
    cd Leukemia-Detection
    ```

2.  **Set up the environment:**
    It is recommended to use the provided virtual environment. If not set up, install the required libraries:
    ```bash
    pip install opencv-python-headless numpy scikit-learn scikit-image matplotlib
    ```

3.  **Execute the script:**
    Run the script from your terminal. The script processes one of the sample images.
    ```bash
    python "leukemia detect.py"
    ```

### MATLAB Instructions

1.  **Open MATLAB.**
2.  **Navigate to the project directory** containing `cancer_detect.m`, `F1.jpg`, and `F2.jpg`.
3.  **Run the script** from the MATLAB command window:
    ```matlab
    cancer_detect
    ```

***

## 🛠️ Dependencies

Ensure you have the following software and libraries installed to run this project.

### For Python
* **Python 3.8+**
* **OpenCV**: For core image processing functions.
* **NumPy**: For numerical operations and array handling.
* **scikit-image**: For advanced image analysis and feature extraction.
* **scikit-learn**: For machine learning algorithms, such as clustering.
* **Matplotlib**: For displaying images and results.

### For MATLAB
* **MATLAB R2018a** or newer.
* **Image Processing Toolbox**: This toolbox is required for segmentation and feature analysis functions like `imsegkmeans` and `regionprops`.

***

## 🤝 Contributing

Contributions are welcome. For major changes, please open an issue first to discuss what you would like to change. To contribute:
1.  Fork the Project.
2.  Create your Feature Branch (`git checkout -b feature/NewFeature`).
3.  Commit your Changes (`git commit -m 'Add some NewFeature'`).
4.  Push to the Branch (`git push origin feature/NewFeature`).
5.  Open a Pull Request.
