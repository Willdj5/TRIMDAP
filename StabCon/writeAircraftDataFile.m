function writeAircraftDataFile(filename, data)
%   writeAircraftDataFile('myData.txt', dataStruct)

fid = fopen(filename, 'w');

if fid == -1
    error('Cannot open file: %s', filename);
end

fprintf(fid, 'Aircraft.m = %.6g;\n\n', data.totalw / 9.81);

fprintf(fid, 'Aircraft.CDi = %.6g;\n', data.stabcon.CDi);
fprintf(fid, 'Aircraft.CDb = %.6g;\n\n', data.stabcon.CDb);

fprintf(fid, '%% WING\n');
fprintf(fid, 'Aircraft.cbar = %.6g;\n', data.stabcon.cbar);
fprintf(fid, 'Aircraft.bw = %.6g;\n', data.cmpnt.cntrlSurf.wing.yl);
fprintf(fid, 'Aircraft.S = %.6g;\n', data.stabcon.S);
fprintf(fid, 'Aircraft.alpha_L0 = %.6g;\n', data.cmpnt.cntrlSurf.wing.alphaL0 * pi/180);
fprintf(fid, 'Aircraft.alpha_wset = %.6g;\n', data.cmpnt.cntrlSurf.wing.(data.use.wing).alpha * pi/180);
fprintf(fid, 'Aircraft.alphaS = %.6g;\n', data.cmpnt.cntrlSurf.wing.alphaSwitch * pi/180);
fprintf(fid, 'Aircraft.CLMAX = %.6g;\n\n', data.cmpnt.cntrlSurf.wing.CLMAX);

fprintf(fid, '%% TAIL\n');
fprintf(fid, 'Aircraft.St = %.6g;\n', data.stabcon.St);
fprintf(fid, 'Aircraft.Sv = %.6g;\n', data.stabcon.Sv);
fprintf(fid, 'Aircraft.alpha_tset = %.6g;\n', data.cmpnt.cntrlSurf.tail.(data.use.tail).alpha * pi/180 - data.cmpnt.cntrlSurf.wing.(data.use.wing).alpha * pi/180);
fprintf(fid, 'Aircraft.depsda = %.6g;\n', data.stabcon.DeDalpha);
fprintf(fid, 'Aircraft.eps_0 = %.6g;\n\n', data.stabcon.e0);

fprintf(fid, '%% STABCON\n');
fprintf(fid, 'Aircraft.CM0 = %.6g;\n', data.stabcon.CM0);
fprintf(fid, 'Aircraft.h = %.6g;\n', data.stabcon.h);
fprintf(fid, 'Aircraft.h0 = %.6g;\n', data.stabcon.h0);
fprintf(fid, 'Aircraft.l = %.6g;\n', data.stabcon.l);
fprintf(fid, 'Aircraft.lt = %.6g;\n', data.stabcon.lt);
fprintf(fid, 'Aircraft.a = %.6g;\n', data.stabcon.a);
fprintf(fid, 'Aircraft.a1 = %.6g;\n', data.stabcon.a1);
fprintf(fid, 'Aircraft.a2 = %.6g;\n', data.stabcon.a2);
fprintf(fid, 'Aircraft.av = %.6g;\n', data.stabcon.av);
fprintf(fid, 'Aircraft.ar = %.6g;\n', data.stabcon.ar);
fprintf(fid, 'Aircraft.aa = %.6g;\n', data.stabcon.aa);

fclose(fid);
end