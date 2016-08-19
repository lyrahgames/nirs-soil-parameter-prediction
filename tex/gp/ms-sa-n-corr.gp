set terminal epslatex size 7cm,5cm
set output "tex/gp/ms-sa-n-corr.tex"

set object 1 rect from graph 0,graph 0 to graph 1,graph 1 fc rgb "#EEEEEE" fs solid 1.0 noborder behind 

# set xl '$p^\m{(SOC)}$'
# set yl '$\hat{p}^\m{(SOC)}$'

set size square

set ytics 0.2
set xtics 0.2

set xr [-0.1:0.8]
set yr [-0.1:0.8]

# set xrange [1370:2700]
# set key box
# set key left height 1 width 1
set grid lt 1 lw 3 lc rgb "#FAFAFA"
unset key
set label "$P^\\m{(N)}$" at graph 0.15,0.85 left front

plot 'pro-files/data/gen/ms-sa-n-corr.csv' using 1:2 with points pt 13 title 'sample',\
	x with lines lt 1 lw 5 lc rgb "#5555FF" title 'identity'