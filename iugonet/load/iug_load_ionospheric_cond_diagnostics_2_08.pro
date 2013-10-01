; docformat = 'IDL'

;+
;
;Name:
;IUG_LOAD_IONOSPHERIC_COND_DIAGNOSTICS_2_08
;
;Purpose:
;
;Syntax:
;
;Keywords:
;
;Code:
;Yukinobu KOYAMA, 05/01/2012
;
;Modifications:
;
;Acknowledgment:
;
;Example:
; IDL> thm_init
; THEMIS> iug_load_ionospheric_cond_diagnostics_2_08
;-

pro iug_load_ionospheric_cond_diagnostics_2_08

  height_bottom=100
  height_top=400
  height_step=1
  mmdd=321

  num_height = (height_top-height_bottom)/height_step+1
  height_array=fltarr(num_height)

  for i=0L,num_height-1 do begin
     height_array(i)=height_bottom+height_step*i
  endfor

;
; Calculation based on Kenichi Maeda's equation
;
  glat=44.6
  glon=2.2
  ltut=0
  time=12
  ssn=160

  iug_load_iri90,mmdd=mmdd,ltut=ltut,time=time,glat=glat,glon=glon,height_bottom=height_bottom,height_top=height_top,height_step=height_step,ssn=ssn,result=result_iri

  set_plot,'ps'
  device,filename='iug_load_ionospheric_cond_diagnostics_2_08.ps',/color

  plot,result_iri[1,*]*1E6,result_iri[0,*],xtitle="Electron Density (m^-3)", $
       ytitle="Altitude (km)",yrange=[0,400],xrange=[1E8,1E13],/xlog, $
       linestyle=0, color=0, title="GLAT=44.6, GLON=2.2, on March 21, by IRI90"
  xyouts,7E11,350,"Solar maximum",color=6
  xyouts,7E11,170,"Noon",color=2
  xyouts,1E10,350,"Solar minimum",color=6
  xyouts,1E10,170,"Midnight",color=2

;
; Calculation2
;
  glat=44.6
  glon=2.2
  ltut=0
  time=12
  ssn=15

  iug_load_iri90,mmdd=mmdd,ltut=ltut,time=time,glat=glat,glon=glon,height_bottom=height_bottom,height_top=height_top,height_step=height_step,ssn=ssn,result=result_iri

  oplot,result_iri[1,*]*1E6,result_iri[0,*],linestyle=0, color=3

;
; Calculation3
;
  glat=44.6
  glon=2.2
  ltut=0
  time=0
  ssn=160

  iug_load_iri90,mmdd=mmdd,ltut=ltut,time=time,glat=glat,glon=glon,height_bottom=height_bottom,height_top=height_top,height_step=height_step,ssn=ssn,result=result_iri

  oplot,result_iri[1,*]*1E6,result_iri[0,*],linestyle=0, color=4

;
; Calculation4
;
  glat=44.6
  glon=2.2
  ltut=0
  time=0
  ssn=15

  iug_load_iri90,mmdd=mmdd,ltut=ltut,time=time,glat=glat,glon=glon,height_bottom=height_bottom,height_top=height_top,height_step=height_step,ssn=ssn,result=result_iri

  oplot,result_iri[1,*]*1E6,result_iri[0,*],linestyle=0, color=5

; Solar maximum, noon
  a=[1.04E+08,1.21E+08,1.42E+08,1.67E+08,1.92E+08,2.21E+08,2.59E+08,3.03E+08,3.49E+08,4.09E+08,4.79E+08,5.52E+08,6.47E+08,7.45E+08,8.73E+08,1.02E+09,1.16E+09,1.34E+09,1.57E+09,1.80E+09,2.11E+09,2.51E+09,3.08E+09,3.85E+09,4.87E+09,5.98E+09,7.82E+09,1.04E+10,1.36E+10,1.83E+10,2.55E+10,3.39E+10,4.65E+10,5.99E+10,7.70E+10,9.61E+10,1.24E+11,1.49E+11,1.78E+11,1.70E+11,1.65E+11,1.73E+11,1.90E+11,2.09E+11,2.26E+11,2.49E+11,2.69E+11,2.91E+11,3.10E+11,3.36E+11,3.64E+11,3.94E+11,4.13E+11,4.62E+11,5.32E+11,6.04E+11,6.85E+11,7.78E+11,8.69E+11,9.71E+11,1.08E+12,1.21E+12,1.33E+12,1.47E+12,1.56E+12,1.69E+12,1.77E+12,1.86E+12,1.92E+12,1.98E+12,2.02E+12,2.02E+12,2.02E+12,1.99E+12,1.96E+12,1.90E+12,1.79E+12,1.76E+12,1.71E+12]
  b=[63.9401,64.7305,64.7412,65.5316,66.321,66.3306,66.3412,67.9114,67.1413,67.9317,68.7221,70.2912,70.3019,71.8709,73.4411,75.0112,76.5792,78.1483,80.4982,82.0672,82.8577,84.4289,84.4428,84.4577,85.2535,85.2674,85.2855,86.0845,86.1026,87.6824,88.4845,89.2835,90.0846,90.8814,92.458,94.0324,94.8292,97.1812,103.431,109.665,115.121,118.244,124.488,130.732,136.975,143.999,151.022,157.265,164.287,171.31,177.553,184.576,191.597,196.283,200.191,204.878,209.565,214.252,219.718,224.403,229.869,236.114,242.359,248.603,255.625,262.648,269.668,277.469,285.268,292.288,333.615,323.478,311.782,345.31,357.005,369.478,381.17,391.305,398.321]

; Solar minimum, noon,
  c=[1.01E+08,1.24E+08,1.57E+08,1.64E+08,2.07E+08,2.62E+08,3.23E+08,4.07E+08,5.02E+08,6.34E+08,7.82E+08,9.87E+08,1.24E+09,1.54E+09,1.94E+09,2.50E+09,3.08E+09,3.89E+09,4.91E+09,6.06E+09,7.64E+09,1.31E+10,1.65E+10,2.13E+10,2.68E+10,3.39E+10,4.18E+10,5.03E+10,6.35E+10,7.47E+10,9.43E+10,1.14E+11,1.16E+11,1.22E+11,1.31E+11,1.38E+11,1.48E+11,1.70E+11,2.00E+11,2.30E+11,2.78E+11,3.27E+11,3.85E+11,4.34E+11,4.65E+11,4.88E+11,5.00E+11,4.90E+11,4.68E+11,4.48E+11,4.18E+11,3.99E+11,3.73E+11,3.56E+11,3.33E+11,3.04E+11,2.77E+11,2.53E+11,2.30E+11,2.10E+11,2.01E+11]
  d=[66.8557,66.7718,67.8314,68.9654,68.8723,71.0845,72.1534,74.3656,77.7398,81.1047,83.3263,84.3858,84.2926,85.3615,85.2683,86.3186,85.0821,86.1416,86.0484,87.1173,87.0242,90.268,91.3275,91.225,92.2846,93.3441,93.2603,94.3385,94.2453,96.4855,97.545,100.929,111.293,121.649,133.148,143.503,155.002,164.168,172.171,179.032,187.026,193.877,203.033,213.361,223.707,236.368,244.427,260.574,272.12,285.97,297.525,307.918,319.473,326.408,337.962,348.374,359.938,370.349,380.761,391.172,398.107]

; Solar maximum, midnight
  e=[1.05E+08,1.23E+08,1.44E+08,1.69E+08,1.94E+08,2.27E+08,2.66E+08,3.11E+08,3.64E+08,4.20E+08,4.91E+08,5.75E+08,6.63E+08,7.75E+08,8.93E+08,1.05E+09,1.22E+09,1.43E+09,1.68E+09,1.84E+09,2.16E+09,2.48E+09,2.91E+09,3.40E+09,3.92E+09,4.24E+09,3.63E+09,3.15E+09,2.74E+09,2.34E+09,2.03E+09,1.74E+09,1.48E+09,1.29E+09,1.10E+09,9.55E+08,8.42E+08,8.42E+08,9.55E+08,1.10E+09,1.27E+09,1.44E+09,1.65E+09,1.90E+09,2.23E+09,2.57E+09,2.96E+09,3.40E+09,3.92E+09,4.44E+09,5.04E+09,5.62E+09,6.37E+09,7.11E+09,8.06E+09,9.14E+09,1.04E+10,1.18E+10,1.33E+10,1.51E+10,1.71E+10,1.97E+10,2.24E+10,2.53E+10,2.92E+10,3.36E+10,3.87E+10,4.53E+10,5.22E+10,6.01E+10,6.92E+10,7.97E+10,9.18E+10,1.04E+11,1.20E+11,1.36E+11,1.54E+11,1.75E+11,1.98E+11,2.24E+11,2.50E+11,2.79E+11,3.07E+11,3.32E+11,3.48E+11,3.70E+11,3.94E+11,4.20E+11,4.33E+11,4.47E+11,4.61E+11,4.75E+11,4.75E+11,4.83E+11]


  f=[84.2071,84.1965,84.1858,84.9549,84.9453,85.7144,86.4834,87.2525,87.2419,88.7917,89.5608,90.3299,90.3203,91.0894,92.6392,92.6286,92.6179,93.387,94.1561,94.1497,94.139,94.1294,94.8985,95.6676,97.9972,101.89,109.162,111.501,113.06,114.62,116.179,117.739,120.078,121.637,123.977,126.316,130.994,135.673,140.351,143.47,146.589,148.928,150.487,153.606,155.945,159.064,162.183,165.302,168.421,173.099,177.778,182.456,187.914,192.593,197.271,201.949,207.407,212.086,215.984,220.663,225.341,228.46,233.138,236.257,240.156,243.275,246.394,248.733,252.632,255.75,258.869,261.988,265.887,269.786,273.684,278.363,282.261,286.94,292.398,297.076,302.534,307.992,313.45,319.688,324.366,329.045,336.062,343.08,350.877,358.674,366.472,385.965,373.489,399.22]

; Solar minimum, midnight
  g=[1.06E+08,1.24E+08,1.45E+08,1.70E+08,1.96E+08,2.29E+08,2.68E+08,3.14E+08,3.67E+08,4.23E+08,4.95E+08,5.79E+08,6.67E+08,7.80E+08,8.98E+08,1.05E+09,1.23E+09,1.44E+09,1.68E+09,1.82E+09,1.56E+09,1.35E+09,1.15E+09,1.00E+09,8.56E+08,7.43E+08,6.35E+08,5.51E+08,4.79E+08,4.16E+08,3.66E+08,3.44E+08,3.66E+08,4.15E+08,4.86E+08,5.60E+08,6.44E+08,7.54E+08,8.68E+08,1.00E+09,1.17E+09,1.35E+09,1.55E+09,1.76E+09,1.99E+09,2.26E+09,2.52E+09,2.82E+09,3.19E+09,3.56E+09,4.04E+09,4.51E+09,5.11E+09,5.89E+09,6.78E+09,7.81E+09,8.99E+09,1.04E+10,1.21E+10,1.40E+10,1.63E+10,1.88E+10,2.17E+10,2.53E+10,2.92E+10,3.36E+10,3.87E+10,4.46E+10,5.05E+10,5.82E+10,6.60E+10,7.48E+10,8.48E+10,9.46E+10,1.04E+11,1.12E+11,1.22E+11,1.25E+11,1.29E+11,1.33E+11,1.33E+11,1.31E+11,1.27E+11,1.21E+11,1.17E+11,1.14E+11]
h=[84.9903,84.9903,84.9903,85.77,85.77,86.5497,87.3294,88.1092,88.1092,89.6686,90.4483,91.2281,91.2281,92.0078,93.5673,93.5673,93.5673,94.347,95.1267,102.144,109.162,111.501,113.06,115.4,116.179,118.519,120.078,121.637,123.197,126.316,130.214,133.333,137.232,141.131,144.25,147.368,149.708,152.047,155.166,157.505,159.844,163.743,166.862,170.76,175.439,180.897,185.575,191.033,196.491,201.17,205.848,211.306,215.205,219.103,223.002,226.121,229.24,232.359,234.698,237.037,239.376,241.715,244.834,247.173,250.292,254.191,257.31,260.429,264.327,268.226,272.125,276.803,282.261,286.94,293.177,300.195,307.212,314.23,321.248,331.384,351.657,359.454,368.031,377.388,385.185,392.982]

  oplot,a,b,linestyle=1,color=0
  oplot,c,d,linestyle=1,color=0
  oplot,e,f,linestyle=1,color=0
  oplot,g,h,linestyle=1,color=0

  device,/close
  set_plot,'x'

end