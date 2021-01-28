function show_metric(metric)
% show metric
%

disp(sprintf('bad areas             : %g',metric(1)));
disp(sprintf('square error (obj/prm): %g, %g',metric( 2),metric( 3)));
disp(sprintf('area scaling (obj/prm): %g, %g',metric( 4),metric( 5)));
disp(sprintf('L2 (obj/prm)          : %g, %g',metric( 6),metric( 7)));
disp(sprintf('L2b (obj/prm)         : %g, %g',metric( 8),metric( 9)));
disp(sprintf('Linf, Linfb           : %g, %g',metric(10),metric(11)));
disp(sprintf('mgmstch iter          : %g, %g',metric(12),metric(13)));
disp(sprintf('seconds, minutes      : %g, %g',metric(14),metric(14)/60));

return;
