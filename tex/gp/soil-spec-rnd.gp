set terminal epslatex size 14cm,6cm
set output "tex/gp/soil-spec-rnd.tex"

set object 1 rect from graph 0,graph 0 to graph 1,graph 1 fc rgb "#EEEEEE" fs solid 1.0 noborder behind 

set xl '$\lambda \ [\m{nm}]$'
set yl '$-\lg \varrho(\lambda)$'

set ytics 0.05
set xtics 200

set xrange [1370:2700]

unset key
set grid lt 1 lw 3 lc rgb "#FAFAFA"

plot 'pro-files/data/soil-spec-rnd.csv' using 1:2 with lines lt 1 lw 4 lc rgb "black",\
	'' using 1:3 with lines lt 1 lw 4 lc rgb "red",\
	'' using 1:4 with lines lt 1 lw 4 lc rgb "blue",\
	'' using 1:5 with lines lt 1 lw 4 lc rgb "green",\
	'' using 1:6 with lines lt 1 lw 4 lc rgb "orange",\
	'' using 1:7 with lines lt 1 lw 4 lc rgb "violet"