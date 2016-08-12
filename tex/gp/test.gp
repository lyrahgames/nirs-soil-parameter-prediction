set object 1 rect from graph 0,graph 0 to graph 1,graph 1 fc rgb "gray" fs solid 1.0 noborder behind 
set grid
unset key
plot 'pro-files/data/gen/ms-sa-soc-par.csv' using 1:(abs($2)) with impulses lt 1 lw 2