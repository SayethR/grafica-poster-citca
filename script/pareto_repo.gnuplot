# =====================================================================
# Frontera de Pareto Extendida (N = 22 sistemas con Tags Sincronizados)
# Versión para Repositorio GitHub (Anexo Técnico del Póster CITCA)
# =====================================================================

set terminal pngcairo enhanced font "Helvetica,12" size 1260,900 rounded
set output "../figures/pareto_frontier_full.png"

set lmargin 9.5
set rmargin 4.0
set tmargin 3.2
set bmargin at screen 0.22

set title "Comparativa de Detección de Objetos en Tiempo Real: GPU (FP32) vs. FPGA Optimizada (Hozhabr \\& Giorgi, 2025)" \
    font "Helvetica-Bold,13" offset 0,0.4

set border lw 1.8
set tics scale 1.1
set tics font "Helvetica,12"
set tics nomirror
set xlabel "Eficiencia Energética Efectiva [FPS/W] (escala logarítmica)" font "Helvetica,13" offset 0,-0.5
set ylabel "Precisión media promedio [mAP %]" font "Helvetica,13" offset -1.0,0
set xrange [0.014 : 115.0]
set yrange [16.0 : 87.5]
set logscale x
set format x "%g"
set mxtics 9

set grid xtics ytics linetype 1 linecolor rgb "#D8D8D8" linewidth 0.9

set key at screen 0.52,0.02 bottom center vertical maxrows 3 box \
    spacing 1.2 samplen 1.8 width 0.8 font "Helvetica,11"

set arrow from graph 0.80,0.68 to graph 0.93,0.81 lw 3 lc rgb "#555555" size screen 0.018,20 filled
set label "Mejor" at graph 0.80,0.64 left font "Helvetica-Bold,12" tc rgb "#555555"

$PARETO << EOD
34.89  81.19
20.83  82.60
EOD

# =====================================================================
# TAGS SINCRONIZADOS CON LA TABLA Y BIBLIOGRAFÍA DEL REPOSITORIO ([2]-[22])
# =====================================================================

# --- Nivel 0: GPU Sin Optimizar ---
set label "Faster R-CNN (K40) [2]"    at 0.02,69.90 offset  0.8, 0.0 left   font "Helvetica,9.5" tc rgb "#555555"
set label "SSD (Titan X) [3]"         at 0.18,74.30 offset -0.7,-0.4 right  font "Helvetica,9.5" tc rgb "#555555"
set label "YOLOv2 (Titan X) [4]"      at 0.27,76.80 offset  0.0, 1.0 center font "Helvetica,9.5" tc rgb "#555555"
set label "YOLOv4 (V100) [5]"         at 0.38,41.20 offset  0.8, 0.0 left   font "Helvetica,9.5" tc rgb "#555555"
set label "Tiny-YOLOv2 (Titan X) [4]" at 0.83,57.10 offset -0.7, 0.3 right  font "Helvetica,9.5" tc rgb "#555555"
set label "RT-DETR (T4) [6]"          at 1.54,53.10 offset -0.7,-0.3 right  font "Helvetica,9.5" tc rgb "#555555"

# --- Nivel 1: FPGA Optimización Básica ---
set label "Li et al. [7]"             at 0.92,73.60 offset -0.7,-0.3 right  font "Helvetica,9.5" tc rgb "#1F77B4"
set label "Chang et al. [8]"          at 1.44,49.70 offset -0.7,-0.5 right  font "Helvetica,9.5" tc rgb "#1F77B4"
set label "Cai et al. [9]"            at 3.55,56.80 offset -0.7, 0.4 right  font "Helvetica,9.5" tc rgb "#1F77B4"
set label "Pestana et al. [10]"       at 8.37,31.00 offset  0.7,-0.3 left   font "Helvetica,9.5" tc rgb "#1F77B4"

# --- Nivel 2: FPGA Optimización Intermedia ---
set label "Hosseiny et al. [11]"      at 2.78,34.10 offset -0.7, 0.4 right  font "Helvetica,9.5" tc rgb "#D96B00"
set label "J. Zhang et al. [12]"      at 4.26,77.04 offset -0.7, 0.6 right  font "Helvetica,9.5" tc rgb "#D96B00"
set label "Fan et al. [13]"           at 6.55,20.50 offset  0.7,-0.3 left   font "Helvetica,9.5" tc rgb "#D96B00"
set label "Nguyen et al. [14]"        at 7.65,51.38 offset  0.7,-0.4 left   font "Helvetica,9.5" tc rgb "#D96B00"
set label "D. Zhang et al. [15]"      at 8.42,58.10 offset  0.7, 0.3 left   font "Helvetica,9.5" tc rgb "#D96B00"
set label "Suh et al. [16]"           at 14.24,76.20 offset 0.7,-0.4 left   font "Helvetica,9.5" tc rgb "#D96B00"

# --- Nivel 3: FPGA Co-Diseño Profundo ---
set label "Wang et al. [17]"          at 2.79,74.45 offset  0.7,-0.2 left   font "Helvetica,9.5" tc rgb "#B22222"
set label "Huang et al. [18]"         at 4.80,55.10 offset -0.7,-0.5 right  font "Helvetica,9.5" tc rgb "#B22222"
set label "Anupreetham et al. [19]"   at 5.79,22.80 offset  0.7, 0.4 left   font "Helvetica,9.5" tc rgb "#B22222"
set label "S. Kim et al. [20]"        at 16.55,78.60 offset -0.8, 0.1 right font "Helvetica,9.5" tc rgb "#B22222"
set label "K. Kim et al. [21]"        at 20.83,82.60 offset -0.3, 1.1 center font "Helvetica-Bold,10.5" tc rgb "#8B0000"
set label "M. Kim et al. [22]"        at 34.89,81.19 offset  0.8, 0.0 left  font "Helvetica-Bold,10.5" tc rgb "#8B0000"

plot \
  "../data/pareto_data.dat" using ($6==0 ? $2 : 1/0):3 \
    title "Nivel 0: GPU sin optimizar" \
    with points pt 6 ps 1.5 lw 1.8 lc rgb "#7F7F7F", \
  "../data/pareto_data.dat" using ($6==1 ? $2 : 1/0):3 \
    title "Nivel 1: FPGA optimización básica" \
    with points pt 4 ps 1.5 lw 1.8 lc rgb "#1F77B4", \
  "../data/pareto_data.dat" using ($6==2 ? $2 : 1/0):3 \
    title "Nivel 2: FPGA optimización intermedia" \
    with points pt 8 ps 1.5 lw 1.8 lc rgb "#FF7F0E", \
  $PARETO using 1:2 \
    title "Frontera de Pareto (Tiempo Real >= 30 FPS)" \
    with lines lw 3.0 lc rgb "#9467BD", \
  "../data/pareto_data.dat" using ($6==3 ? $2 : 1/0):3 \
    title "Nivel 3: FPGA co-diseño profundo" \
    with points pt 5 ps 1.6 lc rgb "#D62728"