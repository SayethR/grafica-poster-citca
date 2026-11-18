# =====================================================================
# Frontera de Pareto Extendida (N = 22 sistemas etiquetados)
# Versión para Repositorio GitHub (Anexo Técnico del Póster CITCA)
# =====================================================================

set terminal pngcairo enhanced font "Helvetica,12" size 1260,900 rounded
set output "../figures/pareto_frontier_full.png"

# --- Márgenes ---
set lmargin 9.5
set rmargin 4.0
set tmargin 3.2
set bmargin at screen 0.22

# --- Título contextual (condiciones experimentales) ---
set title "Comparativa de Detección de Objetos en Tiempo Real (Dataset: PASCAL VOC | Resoluciones: 300x300 a 416x416)" \
    font "Helvetica-Bold,13" offset 0,0.4

# --- Ejes y bordes ---
set border lw 1.8
set tics scale 1.1
set tics font "Helvetica,12"
set tics nomirror
set xlabel "Eficiencia Energética Efectiva [FPS/W] (escala logarítmica)" font "Helvetica,13" offset 0,-0.5
set ylabel "Precisión media promedio [mAP %]" font "Helvetica,13" offset -1.0,0
set xrange [0.035 : 115.0]
set yrange [48.0 : 81.5]
set logscale x
set format x "%g"
set mxtics 9

# --- Rejilla ---
set grid xtics ytics linetype 1 linecolor rgb "#D8D8D8" linewidth 0.9

# --- Leyenda debajo de la gráfica ---
set key at screen 0.52,0.02 bottom center vertical maxrows 3 box \
    spacing 1.2 samplen 1.8 width 0.8 font "Helvetica,11"

# --- Flecha "Mejor" ---
set arrow from graph 0.80,0.77 to graph 0.93,0.90 lw 3 lc rgb "#555555" size screen 0.018,20 filled
set label "Mejor" at graph 0.80,0.73 left font "Helvetica-Bold,12" tc rgb "#555555"

# --- Frontera de Pareto (Sistemas no dominados con >= 30 FPS) ---
$PARETO << EOD
41.90  64.80
17.55  68.50
11.50  70.40
 3.46  76.80
EOD

# =====================================================================
# ETIQUETAS DE LOS 22 SISTEMAS (Sincronizadas con IDs de la tabla)
# =====================================================================

# --- Nivel 0: Sin optimizar (CPU / GPU FP32) ---
set label "[N0-1] ARM Cortex-A57"   at 0.06,67.60  offset  0.9, 0.0 left   font "Helvetica,10" tc rgb "#555555"
set label "[N0-7] Titan X (YOLOv2)" at 0.36,76.80  offset -0.4, 1.0 center font "Helvetica,10" tc rgb "#555555"
set label "[N0-8] Snapdragon 865"   at 0.76,77.20  offset  0.8, 0.8 left   font "Helvetica,10" tc rgb "#555555"

# Grupo colapsado en mAP=57.1% (X = 1.07 a 1.51) -> Desplegado con líneas guía
set arrow from 1.07,57.10 to 0.55,61.20 nohead lw 0.9 lc rgb "#999999"
set label "[N0-4] Jetson TX2 Base"  at 0.55,61.40  right font "Helvetica,9.5" tc rgb "#555555"

set arrow from 1.11,57.10 to 0.55,59.50 nohead lw 0.9 lc rgb "#999999"
set label "[N0-5] RTX 3050 Base"     at 0.55,59.60  right font "Helvetica,9.5" tc rgb "#555555"

set arrow from 1.17,57.10 to 0.55,57.80 nohead lw 0.9 lc rgb "#999999"
set label "[N0-6] Titan X (Tiny)"    at 0.55,57.80  right font "Helvetica,9.5" tc rgb "#555555"

set arrow from 1.19,57.10 to 0.55,55.80 nohead lw 0.9 lc rgb "#999999"
set label "[N0-2] Ryzen 5 LP"        at 0.55,55.70  right font "Helvetica,9.5" tc rgb "#555555"

set arrow from 1.51,57.10 to 1.65,54.20 nohead lw 0.9 lc rgb "#999999"
set label "[N0-3] Ryzen 5 MT"        at 1.65,54.00  left  font "Helvetica,9.5" tc rgb "#555555"

# --- Nivel 1: GPU embebida / Móvil optimizada ---
set label "[N1-1] Jetson TX2 TRT"    at 2.81,57.00  offset  0.9, 0.0 left   font "Helvetica,10"  tc rgb "#1F77B4"
set label "[N1-2] Mini-YOLOv4 Nano"  at 2.56,68.40  offset -0.9, 0.0 right  font "Helvetica,10"  tc rgb "#1F77B4"
set label "[N1-3] YOLObile\nMobile"  at 3.82,71.50  offset  0.8,-0.3 left   font "Helvetica,9.5" tc rgb "#1F77B4"

# --- Nivel 2: FPGA estándar ---
set label "[N2-1] Tinier-YOLO QNN"   at 8.06,50.10  offset -0.9, 0.2 right  font "Helvetica,10" tc rgb "#D96B00"
set label "[N2-2] BiDet ZC706"       at 23.57,51.68 offset -0.9, 0.2 right  font "Helvetica,10" tc rgb "#D96B00"
set label "[N2-3] Hozhabr KV260"     at 27.27,57.10 offset  0.0, 1.1 center font "Helvetica,10" tc rgb "#D96B00"

# --- Nivel 3: FPGA co-diseño profundo (y Frontera de Pareto) ---
set label "[N3-1] Winograd ZCU102"   at 9.06,62.50  offset -0.9, 0.0 right  font "Helvetica,10" tc rgb "#B22222"
set label "[N3-2] AHCO-YOLO-T"       at 41.90,64.80 offset -0.5,-1.2 center font "Helvetica-Bold,10.5" tc rgb "#8B0000"
set label "[N3-3] Nakahara ZCU102"   at 9.07,67.60  offset -0.9, 0.0 right  font "Helvetica,10" tc rgb "#B22222"
set label "[N3-4] SkyNet + DVFS"     at 17.55,68.50 offset  0.9, 0.3 left   font "Helvetica-Bold,10.5" tc rgb "#8B0000"
set label "[N3-5] Auto-Accel"        at 11.50,70.40 offset  0.9, 0.4 left   font "Helvetica-Bold,10.5" tc rgb "#8B0000"
set label "[N3-6] Liew YOLOv4+KD"    at 2.90,71.50  offset -0.9, 0.1 right  font "Helvetica,10" tc rgb "#B22222"
set label "[N3-7] Wang Arria 10"     at 3.44,73.40  offset  0.9, 0.0 left   font "Helvetica,10" tc rgb "#B22222"
set label "[N3-8] Xu YOLOv2 Full"    at 3.46,76.80  offset  0.9, 0.5 left   font "Helvetica-Bold,10.5" tc rgb "#8B0000"

# --- Trazado ---
plot \
  "../data/pareto_data.dat" using ($6==0 ? $2 : 1/0):3 \
    title "Nivel 0: CPU/GPU sin optimizar" \
    with points pt 6 ps 1.5 lw 1.8 lc rgb "#7F7F7F", \
  "../data/pareto_data.dat" using ($6==1 ? $2 : 1/0):3 \
    title "Nivel 1: GPU/Móvil optimizada" \
    with points pt 4 ps 1.5 lw 1.8 lc rgb "#1F77B4", \
  "../data/pareto_data.dat" using ($6==2 ? $2 : 1/0):3 \
    title "Nivel 2: FPGA IP estándar" \
    with points pt 8 ps 1.5 lw 1.8 lc rgb "#FF7F0E", \
  $PARETO using 1:2 \
    title "Frontera de Pareto (Tiempo Real >= 30 FPS)" \
    with lines lw 3.0 lc rgb "#9467BD", \
  "../data/pareto_data.dat" using ($6==3 ? $2 : 1/0):3 \
    title "Nivel 3: FPGA co-diseño profundo" \
    with points pt 5 ps 1.6 lc rgb "#D62728"