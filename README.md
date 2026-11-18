# Material Suplementario: Comparativa de Detección de Objetos en Tiempo Real (GPU vs. FPGA)

Anexo técnico y reproducible del póster académico:

> **"Importancia de la Optimización de Modelos de IA para Reconocimiento en Imágenes"**  
> *Edwars Sayeth Rodríguez Martínez, Arturo Méndez Patiño, Juan Carlos Olivares Rojas, Adrián Núñez Vieyra, Enrique Reyes Archundia*  
> Maestría en Ciencias en Ingeniería Electrónica — **Instituto Tecnológico de Morelia (TecNM)**.

---

## 1. Metodología de Selección y Condiciones Experimentales

Todos los datos cuantitativos provienen de las tablas comparativas sistematizadas por **Hozhabr y Giorgi (2025)** [1]:

1. **Criterio de Inclusión Arquitectónica:** Se seleccionaron detectores convolucionales de una sola etapa (*DNN One-stage Detectors*, familias **YOLO** y **SSD**) de las Tablas 2, 9 y 10 [1], junto con referencias representativas de dos etapas y Transformers en GPU como contexto de línea base.
2. **Criterio de Completitud de Datos:** De las 19 implementaciones FPGA compiladas en las Tablas 9 y 10, se excluyeron 3 estudios que omiten el consumo de potencia (`Jain et al. [77]`, `Xu et al. [76]`) o la precisión (`Babu et al. [90]`), conservando los **$16$ aceleradores FPGA** con registros completos de `(mAP %, FPS, Potencia W)`.
3. **Líneas Base en GPU Sin Optimizar (Nivel 0):** Se incluyeron **$6$ implementaciones nativas en FP32** reportadas en la Tabla 2 (`NVIDIA GTX Titan X`, `Tesla V100`, `Tesla K40` y `Tesla T4`).
4. **Cálculo de Métricas Normalizadas:**
   * **Eficiencia Energética Efectiva ($\text{FPS/W}$):** Cociente entre la tasa de cuadros ($\text{FPS}$) y la potencia eléctrica ($\text{W}$). Para las plataformas FPGA se utiliza la potencia medida en placa reportada en la Tabla 9; para las GPUs de la Tabla 2 (sin medición de potencia en texto) se normaliza de forma estándar mediante su TDP nominal ($250\text{ W}$ para Titan X / V100, $235\text{ W}$ para K40 y $70\text{ W}$ para T4).
   * **Rendimiento Espacial (*Pixel Throughput*, $\text{MPPS}$):** $\text{FPS} \times \text{Píxeles por fotograma}$, incorporado para normalizar diferencias de resolución de entrada ($192\times 256$ a $1280\times 384$).
   * **Frontera de Pareto:** Conjunto de sistemas no dominados que satisfacen procesamiento continuo en tiempo real ($\ge 30\text{ FPS}$).

---

## 2. Gráfica del Frente de Pareto ($N = 22$ Sistemas Verificados)

![Frente de Pareto Verificado](figures/pareto_frontier_full.png)

---

## 3. Tabla Comparativa Detallada de Especificaciones ($N = 22$)

> **Nota de trazabilidad:** La columna **Tag en Gráfica** coincide exactamente con la etiqueta de cada punto en la figura superior y con el número de referencia (`[2]`–`[22]`) en la Sección 4. Todos los datos fueron compilados de la revisión sistemática de Hozhabr y Giorgi (2025) [1].

### A. Nivel 0 — Líneas Base en GPU Sin Optimizar (FP32)

| Tag en Gráfica | Modelo de IA (Backbone) | Plataforma GPU | Dataset | Resolución | Precisión (mAP) | Velocidad (FPS) | TDP Nominal (W) | Eficiencia (FPS/W) |
| :--- | :--- | :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **`Faster R-CNN (K40) [2]`** | Faster R-CNN (VGG-16, 2 etapas) | NVIDIA Tesla K40 | PASCAL VOC | $1000\times 600$ | 69.90% | 5.00 | 235.0 W | 0.02 |
| **`SSD (Titan X) [3]`** | SSD (ResNet-101) | NVIDIA Titan X | PASCAL VOC | $300\times 300$ | 74.30% | 46.00 | 250.0 W | 0.18 |
| **`YOLOv2 (Titan X) [4]`** | YOLOv2 (DarkNet-19) | NVIDIA GTX Titan X | PASCAL VOC | $416\times 416$ | 76.80% | 67.00 | 250.0 W | 0.27 |
| **`YOLOv4 (V100) [5]`** | YOLOv4 (CSPDarknet-53) | NVIDIA Tesla V100 | MS COCO | $416\times 416$ | 41.20% | 96.00 | 250.0 W | 0.38 |
| **`Tiny-YOLOv2 (Titan X) [4]`** | Tiny-YOLOv2 (DarkNet-19) | NVIDIA GTX Titan X | PASCAL VOC | $416\times 416$ | 57.10% | 207.00 | 250.0 W | 0.83 |
| **`RT-DETR (T4) [6]`** | RT-DETR (ResNet-50, Transformer) | NVIDIA Tesla T4 | MS COCO | $1024\times 1024$ | 53.10% | 108.00 | 70.0 W | 1.54 |

### B. Niveles 1 a 3 — Implementaciones Optimizadas en FPGA

| Tag en Gráfica | Nivel | Modelo de IA | Precisión (W, A) | Plataforma FPGA (Freq.) | Resolución | mAP (%) | FPS | MPPS | Potencia (W) | FPS/W | GOPS/W | Técnicas Clave Empleadas |
| :--- | :---: | :--- | :---: | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :--- |
| **`Li et al. [7]`** | N1 | YOLOv2 | (8, N/A) | Intel Arria 10 (200 MHz) | $416\times 416$ | 73.60% | 25.00 | 4.32 | 27.20 W | 0.92 | 27.20 | Datos de precisión mixta, diseño paralelo, *pipelining* |
| **`Chang et al. [8]`** | N1 | YOLOv3 | (2-8, 2-8) | Xilinx ZCU102 (200 MHz) | $640\times 480$ | 49.70% | 22.00 | 6.75 | 15.30 W | 1.44 | 52.87 | Cuantificación de precisión mixta |
| **`Cai et al. [9]`** | N1 | SSDLite-MobileNetV3 | (16, N/A) | Xilinx XC7Z045 (150 MHz) | $300\times 300$ | 56.80% | 33.14 | 2.98 | 9.34 W | 3.55 | N/A | Winograd + optimización de memoria (*ping-pong*) |
| **`Pestana et al. [10]`** | N1 | Tiny-YOLOv3 | (16, 16) | Xilinx XCKU040 (143 MHz) | $768\times 576$ | 31.00% | 32.40 | 14.33 | 3.87 W | 8.37 | 46.51 | Cuantificación dinámica post-entrenamiento (PTQ) |
| **`Hosseiny et al. [11]`** | N2 | Tiny-YOLOv7 | (13, 13) | Xilinx XC7Z100 (100 MHz) | $640\times 640$ | 34.10% | 30.00 | 12.28 | 10.79 W | 2.78 | N/A | Modificación de código, *pipelining*, reuso de datos |
| **`J. Zhang et al. [12]`** | N2 | Tiny-YOLOv2 | (8, 8) | Xilinx ZC706 (200 MHz) | $1280\times 384$ | 77.04% | 43.70 | 21.47 | 10.25 W | 4.26 | 45.30 | Compartición de recursos, *pipelining*, opt. aritmética |
| **`Fan et al. [13]`** | N2 | SSDLite-MobileNetV2 | (8, 8) | Xilinx ZC706 (100 MHz) | $224\times 224$ | 20.50% | 64.80 | 3.25 | 9.90 W | 6.55 | N/A | Cuantificación parcial, compartición, poda de canales |
| **`Nguyen et al. [14]`** | N2 | Tiny-YOLOv2 | (1, 6) | Xilinx VC707 (200 MHz) | $416\times 416$ | 51.38% | 66.56 | 11.51 | 8.70 W | 7.65 | 53.29 | Pesos binarios, cuantificación QAT, reuso de datos |
| **`D. Zhang et al. [15]`** | N2 | Tiny-YOLOv3 | (8, 8) | Xilinx XC7K325T (200 MHz) | $416\times 416$ | 58.10% | 65.70 | 11.36 | 7.80 W | 8.42 | 51.40 | Reuso en búfer *ping-pong*, opt. acceso a memoria |
| **`Suh et al. [16]`** | N2 | SSD-VGG16 | (8, 8) | Xilinx ZU3EG (200 MHz) | $300\times 300$ | 76.20% | 34.18 | 3.07 | 2.40 W | 14.24 | 57.50 | Cuantificación baja precisión, *loop tiling*, poda |
| **`Wang et al. [17]`** | N3 | YOLOv2 | N/A | Intel Arria-10 GX1150 (211 MHz) | $416\times 416$ | 74.45% | 72.50 | 12.54 | 26.00 W | 2.79 | **81.92** | Poda fina (*Roofline*), co-diseño hardware/software |
| **`Huang et al. [18]`** | N3 | ShuffleNetV2-based | (4, 8) | Xilinx Ultra96 (250 MHz) | $256\times 256$ | 55.10% | 26.90 | 1.76 | 5.60 W | 4.80 | N/A | Reuso de datos, co-diseño algoritmo-hardware |
| **`Anupreetham et al. [19]`** | N3 | SSDLite-MobileNetV1 | N/A | Intel Stratix 10 GX2800 (400 MHz) | $640\times 640$ | 22.80% | **469.00** | **192.00** | 81.00 W | 5.79 | N/A | NMS segmentado (*pipelining*), proc. paralelo |
| **`S. Kim et al. [20]`** | N3 | SSDLite | (16, 16) | Intel Arria 10 (200 MHz) | $224\times 224$ | 78.60% | 84.40 | 4.23 | 5.10 W | 16.55 | N/A | Opt. aritmética y de acceso a memoria, reuso de datos |
| **`K. Kim et al. [21]`** | **N3** | **SqueezeNet-based** | (8, 8) | **Xilinx ZC702 (100 MHz)** | $192\times 256$ | **82.60%** | 43.95 | 4.14 | **2.11 W** | **20.83** | N/A | **Pareto #2:** Simplificación/compresión + proc. paralelo |
| **`M. Kim et al. [22]`** | **N3** | **Tiny-YOLOv3** | (8, 8) | **Xilinx Artix-7 (100 MHz)** | $320\times 320$ | **81.19%** | 76.75 | 4.50 | **2.20 W** | **34.89** | 43.16 | **Pareto #1:** Reuso dinámico + cuantificación hardware |

---

## 4. Referencias Bibliográficas (Exactas de [1])

1. S. H. Hozhabr and R. Giorgi, *"A Survey on Real-Time Object Detection on FPGAs,"* **IEEE Access**, vol. 13, pp. 38195–38238, 2025. DOI: `10.1109/ACCESS.2025.3544515`.
2. S. Ren, K. He, R. Girshick, and J. Sun, *"Faster R-CNN: Towards real-time object detection with region proposal networks,"* in **Proc. Adv. Neural Inf. Process. Syst. (NeurIPS)**, vol. 28, Dec. 2015, pp. 91–99.
3. W. Liu et al., *"SSD: Single shot MultiBox detector,"* in **Proc. 14th Eur. Conf. Comput. Vis. (ECCV)**, Jan. 2016, pp. 21–37.
4. J. Redmon and A. Farhadi, *"YOLO9000: Better, faster, stronger,"* in **Proc. IEEE Conf. Comput. Vis. Pattern Recognit. (CVPR)**, Jul. 2017, pp. 7263–7271.
5. A. Bochkovskiy, C.-Y. Wang, and H.-Y. M. Liao, *"YOLOv4: Optimal speed and accuracy of object detection,"* `arXiv:2004.10934`, 2020.
6. Y. Zhao et al., *"DETRs beat YOLOs on real-time object detection,"* `arXiv:2304.08069`, 2023.
7. Z. Li et al., *"YOLOv2 FPGA Accelerator with Mixed-Precision and Pipelining,"* compilado en **IEEE Access**, vol. 13, Tables 9–10, ref. `[74]`, 2025.
8. M. Chang et al., *"Mixed-Precision Quantization for YOLOv3 on ZCU102,"* compilado en **IEEE Access**, vol. 13, Tables 9–10, ref. `[82]`, 2025.
9. L. Cai, C. Wang, and Y. Xu, *"A real-time FPGA accelerator based on Winograd algorithm for underwater object detection,"* **Electronics**, vol. 10, no. 23, p. 2889, Nov. 2021.
10. D. Pestana et al., *"Post-Training Dynamic Quantization for Tiny-YOLOv3 on FPGA,"* compilado en **IEEE Access**, vol. 13, Tables 9–10, ref. `[85]`, 2025.
11. A. Hosseiny et al., *"Tiny-YOLOv7 FPGA Implementation,"* compilado en **IEEE Access**, vol. 13, Tables 9–10, ref. `[92]`, 2025.
12. J. Zhang et al., *"Tiny-YOLOv2 High-Throughput Accelerator on ZC706,"* compilado en **IEEE Access**, vol. 13, Tables 9–10, ref. `[48]`, 2025.
13. X. Fan et al., *"Channel Pruning and Partial Quantization for SSDLite on ZC706,"* compilado en **IEEE Access**, vol. 13, Tables 9–10, ref. `[47]`, 2025.
14. D. T. Nguyen, T. N. Nguyen, H. Kim, and H.-J. Lee, *"A high-throughput and power-efficient FPGA implementation of YOLO CNN for object detection,"* **IEEE Trans. Very Large Scale Integr. (VLSI) Syst.**, vol. 27, no. 8, pp. 1861–1873, Aug. 2019.
15. D. Zhang et al., *"End-to-End Hardware-Accelerated Tiny-YOLOv3 on XC7K325T,"* compilado en **IEEE Access**, vol. 13, Tables 9–10, ref. `[86]`, 2025.
16. H.-S. Suh, J. Meng, T. Nguyen, V. Kumar, Y. Cao, and J.-S. Seo, *"Algorithm-hardware co-optimization for energy-efficient drone detection on resource-constrained FPGA,"* **ACM Trans. Reconfigurable Technol. Syst.**, vol. 16, no. 2, pp. 1–25, Jun. 2023.
17. Z. Wang, K. Xu, S. Wu, L. Liu, L. Liu, and D. Wang, *"Sparse-YOLO: Hardware/software co-design of an FPGA accelerator for YOLOv2,"* **IEEE Access**, vol. 8, pp. 116569–116585, 2020.
18. Q. Huang et al., *"CoDeNet: Efficient deployment of input-adaptive object detection on embedded FPGAs,"* in **Proc. ACM/SIGDA Int. Symp. Field-Program. Gate Arrays (FPGA)**, Feb. 2021, pp. 206–216.
19. A. Anupreetham et al., *"High throughput FPGA-based object detection via algorithm-hardware codesign,"* **ACM Trans. Reconfigurable Technol. Syst.**, vol. 17, no. 1, pp. 1–20, Mar. 2024.
20. S. Kim et al., *"SSDLite Hardware Accelerator on Intel Arria 10,"* compilado en **IEEE Access**, vol. 13, Tables 9–10, ref. `[46]`, 2025.
21. K. Kim, S.-J. Jang, J. Park, E. Lee, and S.-S. Lee, *"Lightweight and energy-efficient deep learning accelerator for real-time object detection on edge devices,"* **Sensors**, vol. 23, no. 3, p. 1185, Jan. 2023.
22. M. Kim et al., *"Dynamic Data Reuse and Hardware-Friendly Quantization for Tiny-YOLOv3 on Artix-7,"* compilado en **IEEE Access**, vol. 13, Tables 9–10, ref. `[84]`, 2025.