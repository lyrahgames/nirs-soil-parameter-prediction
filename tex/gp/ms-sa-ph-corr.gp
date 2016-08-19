set terminal epslatex size 7cm,5cm
set output "tex/gp/ms-sa-ph-corr.tex"

set object 1 rect from graph 0,graph 0 to graph 1,graph 1 fc rgb "#EEEEEE" fs solid 1.0 noborder behind 

# set xl '$p^\m{(SOC)}$'
# set yl '$\hat{p}^\m{(SOC)}$'

set size square

set ytics 1
set xtics 1

set xr [3.5:8]
set yr [3.5:8]

# set xrange [1370:2700]
# set key box
# set key left height 1 width 1
set grid lt 1 lw 3 lc rgb "#FAFAFA"
unset key
set label "$\\overline{\\m{pH}}$" at graph 0.15,0.85 left front

plot 'pro-files/data/gen/ms-sa-ph-corr.csv' using 1:2 with points pt 13 title 'sample',\
	x with lines lt 1 lw 5 lc rgb "#5555FF" title 'identity'