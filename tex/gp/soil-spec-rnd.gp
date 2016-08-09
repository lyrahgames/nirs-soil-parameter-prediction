set terminal epslatex size 14cm,6cm
set output "tex/gp/soil-spec-rnd.tex"

set xl '$\lambda \ [\m{nm}]$'
set yl '$-\lg \varrho(\lambda)$'

set ytics 0.05
set xtics 200

set xrange [1370:2700]

plot 'pro-files/data/soil-spec-rnd.csv' using 1:2 with lines lt 1 lw 4 lc rgb "black" notitle,\
	'' using 1:3 with lines lt 1 lw 4 lc rgb "red" notitle,\
	'' using 1:4 with lines lt 1 lw 4 lc rgb "blue" notitle,\
	'' using 1:5 with lines lt 1 lw 4 lc rgb "green" notitle,\
	'' using 1:6 with lines lt 1 lw 4 lc rgb "orange" notitle,\
	'' using 1:7 with lines lt 1 lw 4 lc rgb "violet" notitle