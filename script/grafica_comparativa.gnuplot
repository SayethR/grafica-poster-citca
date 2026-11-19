# =====================================================================
# Eficiencia energética vs. precisión por nivel de optimización
# Versión del repositorio: misma figura que la Figura 1 del póster, pero con las
# etiquetas numeradas según las referencias del README (trazabilidad tabla <-> gráfica)
# Datos: ../data/sistemas.dat (N = 22, Hozhabr & Giorgi 2025, Tablas 2, 9 y 10)
# Etiquetas: GPUs por modelo y FPGAs por primer autor, seguidos de su referencia
# original según la Sección 4 del README ([2]-[22]). Son idénticas a la columna
# "Etiqueta" de la tabla del README y de ../data/sistemas.dat.
# En negritas y con flechas verdes: las comparaciones justas (GPU -> FPGA del mismo modelo). Cada etiqueta está en una posición fija
# (coordenadas de datos) unida a su punto con una línea guía.
# Lienzo 6.4x6.2 in (se escala ~1.9x en el póster)
# Uso: cd script && gnuplot grafica_comparativa.gnuplot
#      PNG para el README: pdftoppm -png -r 150 -singlefile ../figures/eficiencia_vs_precision.pdf ../figures/eficiencia_vs_precision
# =====================================================================

set terminal pdfcairo enhanced font "Helvetica,16" size 6.4,6.2
set output "../figures/eficiencia_vs_precision.pdf"
set encoding utf8

# --- Área de la gráfica fija en coordenadas de pantalla ---
set lmargin at screen 0.20
set rmargin at screen 0.92
set bmargin at screen 0.17
set tmargin at screen 0.93

# --- Ejes y bordes ---
set border lw 2
set tics scale 1.2
set tics font "Helvetica,16"
set tics nomirror
set xlabel "Eficiencia: imágenes por segundo por watt [FPS/W]" font "Helvetica,15" offset 0,-0.4
set ylabel "Precisión [mAP %]" font "Helvetica,16" offset -0.8,0
set xrange [0.01 : 200.0]
set yrange [15.0 : 95.0]
set logscale x
set format x "%g"
set mxtics 9

# --- Rejilla ---
set grid xtics ytics linetype 1 linecolor rgb "#C8C8C8" linewidth 1

# --- Leyenda debajo de la gráfica en 2 columnas ---
set key at screen 0.56,0.005 bottom center vertical maxrows 2 box \
    spacing 1.25 samplen 1.5 width 0.5 font "Helvetica,14"

# --- Fondo blanco detrás del texto de las etiquetas ---
set style textbox opaque fillcolor rgb "white" noborder margins 0.4,0.15

# --- Flecha "Mejor" (esquina inferior izquierda, apunta hacia arriba-derecha) ---
set arrow from graph 0.04,0.06 to graph 0.17,0.20 lw 4 lc rgb "#555555" size screen 0.02,20 filled front
set label "Mejor" at graph 0.03,0.025 left font "Helvetica,16" tc rgb "#555555" front


# --- Nivel 0: GPU sin optimizar ---
set arrow from 0.02,69.9 to 0.014,63.5 nohead lw 1 lc rgb "#CFCFCF" back
set label "Faster R-CNN [2]" at 0.014,63.5 left boxed font "Helvetica,12" tc rgb "#9A9A9A" front
set arrow from 0.18,74.3 to 0.06,82.0 nohead lw 1 lc rgb "#CFCFCF" back
set label "SSD [3]" at 0.06,82.0 center boxed font "Helvetica,12" tc rgb "#9A9A9A" front
set arrow from 0.27,76.8 to 0.13,89.0 nohead lw 1.2 lc rgb "#8F8F8F" back
set label "YOLOv2 [4]" at 0.13,89.0 center boxed font "Helvetica:Bold,12.5" tc rgb "#333333" front
set arrow from 0.38,41.2 to 0.2,35.5 nohead lw 1 lc rgb "#CFCFCF" back
set label "YOLOv4 [5]" at 0.2,35.5 center boxed font "Helvetica,12" tc rgb "#9A9A9A" front
set arrow from 0.83,57.1 to 0.33,57.5 nohead lw 1.2 lc rgb "#8F8F8F" back
set label "Tiny-YOLOv2 [4]" at 0.33,57.5 right boxed font "Helvetica:Bold,12.5" tc rgb "#333333" front
set arrow from 1.54,53.1 to 0.45,51.0 nohead lw 1 lc rgb "#CFCFCF" back
set label "RT-DETR [6]" at 0.45,51.0 right boxed font "Helvetica,12" tc rgb "#9A9A9A" front

# --- Nivel 1: FPGA básica ---
set arrow from 0.92,73.6 to 0.55,67.0 nohead lw 1.2 lc rgb "#8F8F8F" back
set label "Li [7]" at 0.55,67.0 center boxed font "Helvetica:Bold,12.5" tc rgb "#0B5FA5" front
set arrow from 1.44,49.7 to 1.6,43.5 nohead lw 1 lc rgb "#CFCFCF" back
set label "Chang [8]" at 1.6,43.5 center boxed font "Helvetica,12" tc rgb "#7FA6CC" front
set arrow from 3.55,56.8 to 2.2,64.0 nohead lw 1 lc rgb "#CFCFCF" back
set label "Cai [9]" at 2.2,64.0 center boxed font "Helvetica,12" tc rgb "#7FA6CC" front
set arrow from 8.37,31.0 to 16.0,34.0 nohead lw 1 lc rgb "#CFCFCF" back
set label "Pestana [10]" at 16.0,34.0 left boxed font "Helvetica,12" tc rgb "#7FA6CC" front

# --- Nivel 2: FPGA intermedia ---
set arrow from 2.78,34.1 to 1.4,31.0 nohead lw 1 lc rgb "#CFCFCF" back
set label "Hosseiny [11]" at 1.4,31.0 right boxed font "Helvetica,12" tc rgb "#E3A56E" front
set arrow from 4.26,77.04 to 3.0,90.0 nohead lw 1 lc rgb "#CFCFCF" back
set label "J. Zhang [12]" at 3.0,90.0 center boxed font "Helvetica,12" tc rgb "#E3A56E" front
set arrow from 6.55,20.5 to 13.0,18.0 nohead lw 1 lc rgb "#CFCFCF" back
set label "Fan [13]" at 13.0,18.0 left boxed font "Helvetica,12" tc rgb "#E3A56E" front
set arrow from 7.65,51.38 to 14.0,50.0 nohead lw 1.2 lc rgb "#8F8F8F" back
set label "Nguyen [14]" at 14.0,50.0 left boxed font "Helvetica:Bold,12.5" tc rgb "#B85400" front
set arrow from 8.42,58.1 to 14.0,63.0 nohead lw 1 lc rgb "#CFCFCF" back
set label "D. Zhang [15]" at 14.0,63.0 left boxed font "Helvetica,12" tc rgb "#E3A56E" front
set arrow from 14.24,76.2 to 30.0,70.0 nohead lw 1 lc rgb "#CFCFCF" back
set label "Suh [16]" at 30.0,70.0 left boxed font "Helvetica,12" tc rgb "#E3A56E" front

# --- Nivel 3: FPGA co-diseño ---
set arrow from 2.79,74.45 to 1.6,82.0 nohead lw 1.2 lc rgb "#8F8F8F" back
set label "Wang [17]" at 1.6,82.0 right boxed font "Helvetica:Bold,12.5" tc rgb "#A00D25" front
set arrow from 4.8,55.1 to 5.0,43.5 nohead lw 1 lc rgb "#CFCFCF" back
set label "Huang [18]" at 5.0,43.5 left boxed font "Helvetica,12" tc rgb "#D98A8A" front
set arrow from 5.79,22.8 to 2.8,25.0 nohead lw 1 lc rgb "#CFCFCF" back
set label "Anupreetham [19]" at 2.8,25.0 right boxed font "Helvetica,12" tc rgb "#D98A8A" front
set arrow from 16.55,78.6 to 9.5,86.0 nohead lw 1 lc rgb "#CFCFCF" back
set label "S. Kim [20]" at 9.5,86.0 center boxed font "Helvetica,12" tc rgb "#D98A8A" front
set arrow from 20.83,82.6 to 20.0,92.0 nohead lw 1 lc rgb "#CFCFCF" back
set label "K. Kim [21]" at 20.0,92.0 center boxed font "Helvetica,12" tc rgb "#D98A8A" front
set arrow from 34.89,81.19 to 70.0,87.0 nohead lw 1 lc rgb "#CFCFCF" back
set label "M. Kim [22]" at 70.0,87.0 center boxed font "Helvetica,12" tc rgb "#D98A8A" front

# --- Comparaciones justas: flechas de la GPU a las FPGAs del mismo modelo ---
# (mismo modelo, misma resolución 416x416 y mismo conjunto de datos PASCAL VOC)
set style arrow 9 head filled size screen 0.013,22 lw 3 lc rgb "#3C8D40"
set arrow from 0.27*1.32, 76.80-(76.80-73.60)*0.10 to 0.92*0.74, 73.60+(76.80-73.60)*0.10 as 9 back   # YOLOv2 Titan X -> Li
set arrow from 0.92*1.32, 73.60-(73.60-74.45)*0.10 to 2.79*0.74, 74.45+(73.60-74.45)*0.10 as 9 back   # Li -> Wang (Sparse-YOLO)
set arrow from 0.83*1.32, 57.10-(57.10-51.38)*0.10 to 7.65*0.74, 51.38+(57.10-51.38)*0.10 as 9 back   # Tiny-YOLOv2 Titan X -> Nguyen

# --- Gráfica ---
plot \
  "../data/sistemas.dat" using ($6==0 ? $2 : 1/0):3 \
    title "Nivel 0: GPU sin optimizar" \
    with points pt 6 ps 1.6 lw 3 lc rgb "#555555", \
  "../data/sistemas.dat" using ($6==1 ? $2 : 1/0):3 \
    title "Nivel 1: FPGA básica" \
    with points pt 4 ps 1.6 lw 3 lc rgb "#0B5FA5", \
  "../data/sistemas.dat" using ($6==2 ? $2 : 1/0):3 \
    title "Nivel 2: FPGA intermedia" \
    with points pt 8 ps 1.7 lw 3 lc rgb "#E66A00", \
  "../data/sistemas.dat" using ($6==3 ? $2 : 1/0):3 \
    title "Nivel 3: FPGA co-diseño" \
    with points pt 5 ps 1.7 lc rgb "#C8102E"
