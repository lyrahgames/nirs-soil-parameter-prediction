set terminal epslatex size 14cm,6cm
set output "tex/gp/ms-sa-soc-spec-rnd.tex"

set object 1 rect from graph 0,graph 0 to graph 1,graph 1 fc rgb "#EEEEEE" fs solid 1.0 noborder behind 

set xl '$\lambda \ [\m{nm}]$'
set yl '$-\lg \varrho(\lambda)$'

set ytics 0.05
set xtics 200

set xrange [1370:2700]

unset key
set grid lt 1 lw 3 lc rgb "#FAFAFA"

set label "$P^\\m{(SOC)}$" at 2500,0.525 front right


plot 'pro-files/data/gen/ms-sa-soc-spec-rnd.csv' using 1:7 with impulses lt 1 lw 3 lc rgb "#AAAAAA" notitle,\
	'pro-files/data/soil-spec-rnd.csv' using 1:2 with lines lt 1 lw 4 lc rgb "black" notitle,\
	'' using 1:3 with lines lt 1 lw 4 lc rgb "#FF5555" notitle,\
	'' using 1:4 with lines lt 1 lw 4 lc rgb "#5555FF" notitle,\
	'' using 1:5 with lines lt 1 lw 4 lc rgb "#55FF55" notitle,\
	'' using 1:6 with lines lt 1 lw 4 lc rgb "#FFAA55" notitle,\
	'' using 1:7 with lines lt 1 lw 4 lc rgb "#FF55FF" notitle