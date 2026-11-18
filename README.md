# Análisis Comparativo y Frente de Pareto: Optimización de Modelos de Detección de Objetos en Tiempo Real (CPU, GPU y FPGA)

Material suplementario del póster académico:  
**"Importancia de la Optimización de Modelos de IA para Reconocimiento en Imágenes"**  
*Edwars Sayeth Rodríguez Martínez, Arturo Méndez Patiño, Juan Carlos Olivares Rojas, Adrián Núñez Vieyra, Enrique Reyes Archundia*  
División de Estudios de Posgrado e Investigación — Maestría en Ciencias en Ingeniería Electrónica, **Instituto Tecnológico de Morelia (TecNM)**.

---

## 1. Propósito del Repositorio

Este repositorio contiene la base de datos homologada ($N=22$ sistemas del estado del arte), los criterios metodológicos de evaluación y los scripts de visualización empleados para construir el **Frente de Pareto** entre **Precisión ($\text{mAP \%}$)** y **Eficiencia Energética Efectiva ($\text{FPS/W}$)** presentado en el póster.

El objetivo es contrastar de forma equitativa el desempeño de detectores de objetos ejecutados sin optimización en arquitecturas convencionales (**CPU** y **GPU**) frente a implementaciones optimizadas en dispositivos embebidos y arreglos de compuertas programables en campo (**FPGA**).

---

## 2. Metodología de Selección y Homologación

Para evitar sesgos derivados de comparar tareas o conjuntos de datos heterogéneos, los estudios incluidos fueron filtrados y normalizados bajo cuatro criterios estrictos:

1. **Arquitectura de Detección Equivalente:** Se seleccionaron exclusivamente detectores convolucionales de una sola etapa (*one-stage detectors*) pertenecientes a las familias **YOLO** y **SSD** (incluyendo variantes ligeras co-diseñadas como *SkyNet* y *AHCO-YOLO-T*), por ser el estándar dominante en aplicaciones de tiempo real en el borde (*edge computing*) [1].
2. **Estandarización del Conjunto de Datos (*Dataset*):** Todas las métricas de precisión reportadas corresponden a evaluaciones sobre el *benchmark* **PASCAL VOC** (20 categorías de objetos, umbral de intersección sobre unión $\text{IoU} > 0.5$) con resoluciones de entrada comprendidas entre $300 \times 300$ y $416 \times 416$ píxeles.
3. **Normalización de Métricas de Eficiencia:**
   * **Precisión ($\text{mAP \%}$):** *Mean Average Precision* reportado en el estudio original.
   * **Eficiencia Energética Efectiva ($\text{FPS/W}$):** Calculada a nivel de sistema como el cociente entre la tasa de procesamiento en fotogramas por segundo ($\text{FPS}$) y el consumo total de potencia eléctrica de la plataforma ($\text{W}$) durante la inferencia:
     $$\text{Eficiencia Energética Efectiva} = \frac{\text{Velocidad de Inferencia [FPS]}}{\text{Potencia Total Consumida [W]}}$$
     Se prioriza $\text{FPS/W}$ frente a métricas aritméticas brutas ($\text{GOPS/W}$) porque refleja la energía real consumida por cada fotograma útil procesado en un nodo de videovigilancia.
4. **Criterio de Tiempo Real:** Para el trazado de la **Frontera de Pareto**, se exige el cumplimiento de procesamiento continuo en tiempo real ($\ge 30\text{ FPS}$).

---

## 3. Estratificación Tecnológica y Taxonomía de Optimizaciones

### Niveles de Optimización (N0 – N3)
* **Nivel 0 (`N0` — Línea Base sin Optimizar):** Ejecución nativa en punto flotante de 32 bits (**FP32**) sobre CPU (ARM/x86) y GPU (escritorio y embebida) usando *frameworks* estándar sin compresión del modelo.
* **Nivel 1 (`N1` — Optimización por Compilador/Software en GPU y Móvil):** Despliegue en GPUs embebidas (*NVIDIA Jetson*) o SoCs móviles aplicando cuantificación FP16 mediante *TensorRT* o poda colaborativa GPU-CPU.
* **Nivel 2 (`N2` — Optimización Estándar en FPGA):** Implementaciones en FPGA basadas en núcleos IP genéricos (como *Xilinx Vitis AI DPU* o *FINN/QNN*) que emplean cuantificación uniforme (INT8 o BNN) y almacenamiento local básico sin rediseñar la topología ni el flujo de datos.
* **Nivel 3 (`N3` — Co-Diseño Profundo Algoritmo-Hardware en FPGA):** Arquitecturas personalizadas que integran sinérgicamente múltiples técnicas de compresión algorítmica y aceleración espacial en silicio.

### Códigos de las 10 Técnicas de Optimización Evaluadas [1]
| Código | Categoría | Técnica de Optimización | Mecanismo Principal |
| :--- | :--- | :--- | :--- |
| **`T1`** | Modelo (Software) | **Poda (*Pruning*)** | Eliminación de pesos, filtros o canales redundantes seguida de reentrenamiento. |
| **`T2`** | Modelo (Software) | **Cuantificación** | Reducción de precisión numérica (FP32 $\rightarrow$ FP16, INT8, 4b/8b mixta o 1-bit BNN). |
| **`T3`** | Modelo (Software) | **Destilación del Conocimiento** | Transferencia de conocimiento de un modelo maestro grande a uno estudiante compacto sin costo en hardware. |
| **`T4`** | Modelo (Software) | **HW-NAS** | Búsqueda automatizada de arquitecturas neuronales restringida por latencia y recursos físicos del chip. |
| **`T5`** | Hardware (FPGA) | **Reutilización de Datos** | Retención espacial y temporal de tensores en memorias internas (BRAM/URAM) para evitar accesos a DRAM. |
| **`T6`** | Hardware (FPGA) | **Optimizaciones Matemáticas** | **`T6a` Winograd:** sustituye multiplicaciones por sumas en filtros $3\times 3$. **`T6b` FFT:** convolución en frecuencia. |
| **`T7`** | Hardware (FPGA) | **Arreglos Sistólicos** | Mallas regulares de Elementos de Procesamiento (PE) con comunicación local entre vecinos. |
| **`T8`** | Hardware (FPGA) | **Modificaciones de Código** | Fusión de operadores (`Conv+BN+Act`), desenrollado (*loop unrolling*) y mosaico (*loop tiling*). |
| **`T9`** | Hardware (FPGA) | **Modelo *Roofline*** | Balanceo analítico entre techo de cómputo (GOPS) y ancho de banda de memoria (GB/s). |
| **`T10`** | Hardware (FPGA) | **Segmentación (*Pipelining*)** | Ejecución solapada por etapas mediante búferes *ping-pong*, doble DMA y NMS segmentado. |

---

## 4. Base de Datos Comparativa Completa ($N = 22$ Sistemas en PASCAL VOC)

| ID | Sistema / Trabajo | Plataforma Hardware | Procesador | Modelo (Resolución) | Nivel | Técnicas Activas | Precisión (mAP %) | Velocidad (FPS) | Potencia (W) | Eficiencia (FPS/W) | Estado en Pareto ($\ge 30\text{ FPS}$) |
| :--- | :--- | :--- | :--- | :--- | :---: | :--- | :---: | :---: | :---: | :---: | :--- |
| **`N0-1`** | Nakahara et al. (2018) [2] | ARM Cortex-A57 | CPU ARM | Lightweight YOLOv2 ($416\times 416$) | `N0` | Ninguna (FP32 secuencial) | 67.60% | 0.23 | 3.8 W | 0.06 | Dominado (< 30 FPS) |
| **`N0-2`** | Hozhabr (2025) - LP [3] | AMD Ryzen 5 5600H (LP) | CPU x86 | Tiny-YOLOv2 ($416\times 416$) | `N0` | Ninguna (FP32 bajo consumo) | 57.10% | 2.50 | 2.1 W | 1.19 | Dominado (< 30 FPS) |
| **`N0-3`** | Hozhabr (2025) - MT [3] | AMD Ryzen 5 5600H (MT) | CPU x86 | Tiny-YOLOv2 ($416\times 416$) | `N0` | Ninguna (FP32 multihilo) | 57.10% | 8.00 | 5.3 W | 1.51 | Dominado (< 30 FPS) |
| **`N0-4`** | Darknet Baseline [1] | NVIDIA Jetson TX2 | GPU Embebida | Tiny-YOLOv2 ($416\times 416$) | `N0` | Ninguna (CUDA FP32) | 57.10% | 8.00 | 7.5 W | 1.07 | Dominado (< 30 FPS) |
| **`N0-5`** | Hozhabr (2025) - GPU [3] | NVIDIA GeForce RTX 3050 | GPU | Tiny-YOLOv2 ($416\times 416$) | `N0` | Ninguna (SIMT estándar) | 57.10% | 15.00 | 13.5 W | 1.11 | Dominado (< 30 FPS) |
| **`N0-6`** | Redmon & Farhadi (2017) [4] | NVIDIA GTX Titan X | GPU Escritorio | Tiny-YOLOv2 ($416\times 416$) | `N0` | Ninguna (FP32 Darknet) | 57.10% | **207.00** | 177.0 W | 1.17 | Dominado en FPS/W |
| **`N0-7`** | Redmon & Farhadi (2017) [4] | NVIDIA GTX Titan X | GPU Escritorio | YOLOv2 Completo ($416\times 416$) | `N0` | Ninguna (FP32 Darknet) | 76.80% | 67.00 | 185.0 W | 0.36 | Dominado ($9.6\times$ menor que `N3-8`) |
| **`N0-8`** | Cai et al. (2021) - Base [5] | Qualcomm Snapdragon 865 | CPU/GPU Móvil | YOLOv4 Completo ($416\times 416$) | `N0` | Ninguna (FP32 móvil) | **77.20%** | 3.80 | 5.0 W | 0.76 | No cumple tiempo real (< 30 FPS) |
| **`N1-1`** | Jetson TX2 TensorRT [1] | NVIDIA Jetson TX2 (Max-P) | GPU Embebida | Tiny-YOLOv2 ($416\times 416$) | `N1` | `T2` (FP16), `T8` (Fusión) | 57.00% | 29.50 | 10.5 W | 2.81 | Dominado ($9.7\times$ menor que `N2-3`) |
| **`N1-2`** | Mini-YOLOv4 (2023) [1] | NVIDIA Jetson Nano | GPU Embebida | Mini-YOLOv4 ($416\times 416$) | `N1` | `T2` (FP16), Pirámide ligera | 68.40% | 25.60 | 10.0 W | 2.56 | Dominado (< 30 FPS) |
| **`N1-3`** | YOLObile (2021) [5] | Snapdragon 865 (GPU+CPU) | GPU+CPU Móvil | YOLOv4 Comprimido ($320\times 320$) | `N1` | `T1` (Poda bloques), `T8` (Co-ejec.) | 71.50% | 19.10 | 5.0 W | 3.82 | Sub-óptimo (< 30 FPS) |
| **`N2-1`** | Tinier-YOLO (2022) [1] | Avnet Ultra96-V2 | FPGA MPSoC | Tinier-YOLO ($416\times 416$) | `N2` | `T2` (1b/3b), `T5` (BRAM) | 50.10% | 25.00 | 3.1 W | 8.06 | Dominado |
| **`N2-2`** | BiDet (Zhang et al., 2021) [1, 6] | Xilinx Zynq ZC706 | FPGA | YOLO Binarizado ($320\times 320$) | `N2` | `T1` (Poda), `T2` (1-bit BNN), `T5` | 51.68% | 66.00 | 2.8 W | 23.57 | Dominado por `N2-3` y `N3-2` |
| **`N2-3`** | Hozhabr (2025) - KV260 [3] | AMD Kria KV260 (DPU) | FPGA MPSoC | Tiny-YOLOv2 ($416\times 416$) | `N2` | `T2` (INT8), `T5` (BRAM), `T10` (AXI) | 57.10% | 30.00 | **1.1 W** | 27.27 | **Óptimo Potencia Mínima Absoluta** |
| **`N3-1`** | Cai / Bao et al. (2021) [1, 7] | Xilinx ZCU102 / Kintex-7 | FPGA MPSoC | Tiny-YOLOv3 ($416\times 416$) | `N3` | `T2`, `T5`, `T6a` (Winograd), `T7` | 62.50% | 65.20 | 7.2 W | 9.06 | Dominado en FPS/W (112.5 GOPS/W) |
| **`N3-2`** | **AHCO-YOLO-T (2026)** [8] | **Xilinx ZCU104** | **FPGA MPSoC** | **AHCO-YOLO-T ($320\times 320$)** | `N3` | `T2` (4b/8b), `T4`, `T5` (IS/WS), `T8`, `T10` | **64.80%** | **79.80** | 1.9 W | **41.90** | **Frente de Pareto #1 (Máx. FPS/W)** |
| **`N3-3`** | Nakahara et al. (2018) [2] | Xilinx ZCU102 | FPGA MPSoC | Lightweight YOLOv2 ($416\times 416$) | `N3` | `T2` (BNN+SVR), `T5`, `T8`, `T10` | 67.60% | 40.81 | 4.5 W | 9.07 | Dominado ($158.9\times$ sobre `N0-1`) |
| **`N3-4`** | **SkyNet + DVFS** [1, 9] | **Avnet Ultra96-V2** | **FPGA MPSoC** | **SkyNet ($320\times 320$)** | `N3` | `T2`, `T4`, `T5`, `T8`, `T10` + DVFS | **68.50%** | 38.60 | 2.2 W | **17.55** | **Frente de Pareto #2 (Óptimo DVFS)** |
| **`N3-5`** | **Auto-Accel (SSDLite)** [1, 10] | **Xilinx ZCU102** | **FPGA MPSoC** | **SSDLite-MobileNetV2 ($300\times 300$)** | `N3` | `T2`, `T5`, `T8` (DW-Conv/Tiling), `T10` | **70.40%** | 57.50 | 5.0 W | **11.50** | **Frente de Pareto #3 (Codo 70% mAP)** |
| **`N3-6`** | Liew et al. (YOLOv4+KD) [1] | Xilinx ZCU102 | FPGA MPSoC | YOLOv4 Comprimido ($416\times 416$) | `N3` | `T1` (-56%), `T2` (INT8), `T3` (KD), `T5` | 71.50% | 33.34 | 11.5 W | 2.90 | Dominado en FPS/W por `N3-8` |
| **`N3-7`** | Wang et al. (2020) [1, 11] | Intel Arria 10 GX 1150 | FPGA | YOLOv2 Podado ($416\times 416$) | `N3` | `T1` ($-7\times$), `T2`, `T7`, `T8`, `T9` | 73.40% | 61.90 | 18.0 W | 3.44 | Dominado en FPS/W por `N3-8` |
| **`N3-8`** | **Xu et al. (2021)** [1, 12] | **Xilinx ZCU102 / Virtex-7** | **FPGA** | **YOLOv2 Completo ($416\times 416$)** | `N3` | `T2`, `T5`, `T7`, `T8` (Fusión), `T10` | **76.80%** | 71.00 | 20.5 W | **3.46** | **Frente de Pareto #4 (Máx. mAP RT)** |

---

## 5. Síntesis de Evidencia Cuantitativa

1. **Impacto del hardware y cuantificación a igualdad de modelo (`Tiny-YOLOv2`, $416\times 416$, $57.1\%\text{ mAP}$):**
   * En CPU (`N0-3`) y GPU de escritorio (`N0-6`), la eficiencia se estanca entre **1.17 y 1.51 FPS/W**.
   * Al migrar a una FPGA con DPU cuantificada a INT8 (`N2-3`, Kria KV260), se alcanzan **30.0 FPS** consumiendo **1.1 W** (**27.27 FPS/W**), multiplicando por **$23.3\times$** la eficiencia respecto a la GPU Titan X y por **$9.7\times$** respecto a una Jetson TX2 optimizada con TensorRT FP16 (`N1-1`, 2.81 FPS/W).
2. **Supremacía del co-diseño nativo (`N3-2`, `AHCO-YOLO-T`):**
   * Al combinar búsqueda de arquitecturas consciente del hardware (`T4`), cuantificación dinámica de 4/8 bits (`T2`) y selección adaptativa de flujo de datos *Input/Weight-Stationary* (`T5`), la eficiencia asciende a **41.90 FPS/W** (79.8 FPS a 1.9 W con 64.8% mAP), representando una mejora de **$37.7\times$** frente a las líneas base en GPU.
3. **Ahorro energético en detectores de alta precisión (`YOLOv2 Full`, $76.8\%\text{ mAP}$):**
   * El acelerador sistólico con fusión de operadores (`Conv+BN+LeakyReLU`) en FPGA (`N3-8`, Xu et al.) iguala y supera la velocidad de una GPU Titan X (`N0-7`: 71 FPS vs. 67 FPS), reduciendo la potencia consumida de **185.0 W a 20.5 W** ($-89\%$) y elevando la eficiencia energética en **$9.6\times$** (de 0.36 a 3.46 FPS/W).

---

## 6. Reproducibilidad de la Gráfica

Para regenerar los archivos vectoriales empleados en el póster (requiere `gnuplot` con soporte `cairolatex`):

```bash
cd scripts/
gnuplot pareto_script.gnuplot
```

---

## 7. Referencias Bibliográficas

* **[1]** S. H. Hozhabr and R. Giorgi, *"A Survey on Real-Time Object Detection on FPGAs,"* **IEEE Access**, vol. 13, pp. 38195–38238, 2025. DOI: `10.1109/ACCESS.2025.3544515`. *(Fuente compiladora principal de las tablas comparativas y taxonomía de aceleración).*
* **[2]** H. Nakahara, H. Yonekawa, T. Fujii, and S. Sato, *"A Lightweight YOLOv2: A Binarized CNN with A Parallel Support Vector Regression for an FPGA,"* in **Proc. ACM/SIGDA Int. Symp. Field-Programmable Gate Arrays (FPGA)**, 2018, pp. 31–40.
* **[3]** S. H. Hozhabr, *"From Real-Time Object Detection to Graph Convolutional Networks: Efficient Deep Learning Acceleration on FPGAs,"* Ph.D. dissertation, Dept. Inf. Eng. Math., **University of Siena**, Italy, 2025.
* **[4]** J. Redmon and A. Farhadi, *"YOLO9000: Better, Faster, Stronger,"* in **Proc. IEEE Conf. Comput. Vis. Pattern Recognit. (CVPR)**, 2017, pp. 7263–7271.
* **[5]** Y. Cai et al., *"YOLObile: Real-Time Object Detection on Mobile Devices via Compression-Compilation Co-Design,"* in **Proc. AAAI Conf. Artif. Intell.**, vol. 35, no. 2, pp. 955–963, 2021.
* **[6]** J. Zhang et al., *"BiDet: An Efficient Binarized Object Detector,"* in **Proc. IEEE/CVF Conf. Comput. Vis. Pattern Recognit. (CVPR)**, 2020 / Implementación FPGA compilada en [1].
* **[7]** R. Cai et al. / C. Bao et al., *"Winograd-based Real-Time Object Detection Accelerators on FPGA,"* compilado en **IEEE Access**, vol. 13, 2025 [1].
* **[8]** J. Kim, J.-K. Kang, and Y. Kim, *"AHCO-YOLO: An Algorithm–Hardware Co-Optimization Framework for Energy-Efficient and Real-Time Object Detection on Edge Devices,"* **IEEE Trans. Very Large Scale Integr. (VLSI) Syst.**, vol. 34, no. 2, pp. 402–415, Feb. 2026.
* **[9]** X. Zhang et al., *"SkyNet: A Hardware-Efficient Method for Object Detection and Tracking on Embedded Systems,"* in **Proc. Mach. Learn. Syst. (MLSys)**, 2020 (con extensión DVFS compilada en [1]).
* **[10]** C. Hao et al., *"FPGA/DNN Co-Design: An Efficient Design Methodology for IoT Intelligence on the Edge,"* in **Proc. 56th ACM/IEEE Design Autom. Conf. (DAC)**, 2019 (Auto-Accel SSDLite, compilado en [1]).
* **[11]** W. Wang et al., *"Roofline-Guided Pruning and FPGA Acceleration for YOLOv2 on Intel Arria 10,"* compilado en **IEEE Access**, vol. 13, Table 9–10, 2025 [1].
* **[12]** K. Xu, X. Wang, X. Liu, and D. Wang, *"A Dedicated Hardware Accelerator for Real-Time Acceleration of YOLOv2,"* **J. Real-Time Image Process.**, vol. 18, pp. 481–492, 2021.
