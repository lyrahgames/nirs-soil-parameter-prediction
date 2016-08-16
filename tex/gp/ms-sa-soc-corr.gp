set terminal epslatex size 5.5cm,5cm
set output "tex/gp/ms-sa-soc-corr.tex"

set object 1 rect from graph 0,graph 0 to graph 1,graph 1 fc rgb "#EEEEEE" fs solid 1.0 noborder behind 

# set xl '$p^\m{(SOC)}$'
# set yl '$\hat{p}^\m{(SOC)}$'

set ytics 2
set xtics 2

set xr [-1:10]
set yr [-1:10]

set size square

# set xrange [1370:2700]
# set key box
# set key left height 1 width 1
set grid lt 1 lw 3 lc rgb "#FAFAFA"
unset key
set label "SOC" at 1,8 left front

plot 'pro-files/data/gen/ms-sa-soc-corr.csv' using 1:2 with points pt 13 title 'sample',\
	x with lines lt 1 lw 5 lc rgb "#55AAAA" title 'identity'