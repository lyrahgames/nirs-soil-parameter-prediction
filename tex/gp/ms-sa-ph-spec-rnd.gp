set terminal epslatex size 14cm,6cm
set output "tex/gp/ms-sa-ph-spec-rnd.tex"

set object 1 rect from graph 0,graph 0 to graph 1,graph 1 fc rgb "#EEEEEE" fs solid 1.0 noborder behind 

set xl '$\lambda \ [\m{nm}]$'
set yl '$-\lg \varrho(\lambda)$'

set ytics 0.05
set xtics 200

set xrange [1370:2700]

unset key
set grid lt 1 lw 3 lc rgb "#FAFAFA"

set label "$\\overline{\\m{pH}}$" at 2500,0.525 right front

plot 'pro-files/data/gen/ms-sa-ph-spec-rnd.csv' using 1:7 with impulses lt 1 lw 3 lc rgb "#AAAAAA",\
	'pro-files/data/soil-spec-rnd.csv' using 1:2 with lines lt 1 lw 4 lc rgb "black",\
	'' using 1:3 with lines lt 1 lw 4 lc rgb "#FF5555",\
	'' using 1:4 with lines lt 1 lw 4 lc rgb "#5555FF",\
	'' using 1:5 with lines lt 1 lw 4 lc rgb "#55FF55",\
	'' using 1:6 with lines lt 1 lw 4 lc rgb "#FFAA55",\
	'' using 1:7 with lines lt 1 lw 4 lc rgb "#FF55FF"