;+
;
;Name:
;IUG_LOAD_IONOSPHERIC_COND_DIAGNOSTICS_2_05
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
; THEMIS> iug_load_ionospheric_cond_diagnostics_2_05, yyyy=1987
;-

pro iug_load_ionospheric_cond_diagnostics_2_05, yyyy=yyyy

; validate yyyy
  if yyyy lt 1958 and yyyy ge 2013 then begin
     dprint,"Specify yyyy in 1958 to 2012."
     return 
  endif

  height_bottom=100
  height_top=400
  height_step=10
  mmdd=321

  if height_top ne height_bottom then begin
     num_height = (height_top-height_bottom)/height_step+1
  endif else begin
     num_height = 1
  endelse 

  height_array=fltarr(num_height)

  for i=0L,num_height-1 do begin
     height_array(i)=height_bottom+height_step*i
  endfor

;
; Calculation based on Kenichi Maeda's equation
;
  result = fltarr(6,num_height)

  glat=44.6
  glon=2.2
  ltut=0
  time=12

  for i=0L,num_height-1 do begin
     iug_load_ionospheric_cond, height_bottom=height_bottom, height_top=height_top, height_step=height_step, glat=glat, glon=glon, yyyy=yyyy, mmdd=mmdd, ltut=ltut, time=time, result=result,algorithm=0
  endfor

  set_plot,'ps'
  device,filename='iug_load_ionospheric_cond_diagnostics_2_05.ps',/color

  plot,result[0,*],result[6,*],xtitle="Conductivities (S/m)", $
       ytitle="Altitude (km)",yrange=[0,400],xrange=[1E-8,1E2],/xlog, $
       linestyle=0,color=0, title="GLAT=44.6, GLON=2.2, Solar Minimum conditions on March 21"
  oplot, result[1,*],result[6,*],linestyle=0,color=6
  oplot, result[2,*],result[6,*],linestyle=0,color=2
  xyouts,1E-3,height_bottom+(height_top-height_bottom)/20*18,"  solid line - by Koyama",color=0
  xyouts,1E-3,height_bottom+(height_top-height_bottom)/20*17,"dotted line - by Richmond",color=0

  xyouts,1E0,height_bottom+(height_top-height_bottom)/20*10,"sigma0",color=0
  xyouts,1E-4,height_bottom+(height_top-height_bottom)/20*10,"sigma1",color=6
  xyouts,1E-6,height_bottom+(height_top-height_bottom)/20*10,"sigma2",color=2

; digitized data plot
; s0
  a=[1.07E-08,1.32E-08,1.62E-08,1.99E-08,2.56E-08,3.01E-08,4.03E-08,4.95E-08,6.34E-08,7.48E-08,9.99E-08,1.18E-07,1.57E-07,1.86E-07,2.38E-07,2.93E-07,3.75E-07,4.61E-07,5.67E-07,7.26E-07,9.31E-07,1.14E-06,1.41E-06,1.80E-06,2.22E-06,2.84E-06,3.49E-06,4.29E-06,5.50E-06,6.76E-06,8.31E-06,1.06E-05,1.36E-05,1.68E-05,2.15E-05,2.53E-05,3.25E-05,3.83E-05,5.11E-05,6.29E-05,7.42E-05,9.50E-05,0.0001218,0.000149766,0.000191924,0.000245899,0.000302422,0.000371703,0.000476337,0.000585705,0.000720185,0.000922723,0.00118271,0.00145366,0.00194149,0.00219783,0.00281592,0.00346246,0.00462441,0.00545478,0.00699029,0.00895617,0.0105666,0.01299,0.0173492,0.0222283,0.0262197,0.0336005,0.0413153,0.0507801,0.0624394,0.0767435,0.102476,0.131323,0.161441,0.198467,0.243933,0.299878,0.400429,0.472232,0.580536,0.713381,0.914006,1.0779,1.32484,1.69671,2.00096,2.45884,3.14902,3.56255,4.2005,4.95268,6.34153,7.17432,8.45548,9.96751,11.2765,13.2957,15.67,18.4683,21.7708,25.664,29.0342,32.8264,38.6884,41.9966,45.5686,51.5312,55.9259,58.213,63.1775,68.3934,68.4794,68.5511,71.2203,74.0554,77.0034,77.1001,77.2455,83.1864,83.2735,83.3607,83.448,83.5703,86.6066,90.1485,93.8549,97.6319,97.7137,101.391,101.497,101.625,105.538]
  b=[58.7404,58.7586,58.7767,59.8076,59.8294,60.8566,60.882,61.9128,61.9347,61.9492,62.9873,63.0018,63.0273,64.0545,65.0889,65.1071,66.1416,65.1471,67.1906,67.2124,68.2468,68.265,68.2832,69.3176,71.3611,71.3829,72.4137,73.4446,75.4917,76.5225,76.5407,77.5751,79.6222,80.653,80.6749,81.702,83.7491,83.7637,84.8018,84.8199,84.8345,85.8689,85.8908,85.9089,85.9308,86.9652,85.9708,88.0142,88.036,88.0542,88.0724,89.1068,88.116,90.1595,90.1849,90.1958,91.2303,91.2485,91.2739,92.3011,92.3229,93.3574,93.3719,94.4028,94.4282,95.4627,96.4898,96.5117,96.5298,98.5733,98.5915,100.635,101.673,101.695,102.726,103.756,105.8,106.831,107.869,109.909,110.94,113.996,115.03,117.07,119.113,122.173,124.213,127.269,130.329,133.378,136.43,139.482,143.555,146.604,151.681,155.747,158.795,161.848,166.926,172.003,176.068,180.134,183.182,189.269,194.347,197.392,202.463,207.537,211.594,217.674,221.732,237.941,231.865,226.802,241.995,253.138,264.281,258.205,249.091,290.617,285.554,280.49,275.427,268.339,295.684,301.763,306.83,315.947,311.897,333.166,328.103,322.027,339.245]

; s1
  c=[9.88E-09,1.32E-08,2.08E-08,3.14E-08,4.37E-08,5.60E-08,7.48E-08,1.09E-07,1.64E-07,2.38E-07,3.31E-07,4.24E-07,5.00E-07,5.43E-07,5.00E-07,3.90E-07,3.17E-07,3.30E-07,4.59E-07,7.24E-07,1.09E-06,1.65E-06,2.60E-06,4.10E-06,5.95E-06,9.76E-06,1.47E-05,2.42E-05,3.81E-05,6.01E-05,9.07E-05,0.000121114,0.000175589,0.000206988,0.000154753,0.000111037,7.97E-05,5.96E-05,4.45E-05,3.47E-05,2.94E-05,2.70E-05,2.38E-05,2.18E-05,2.01E-05,1.77E-05,1.50E-05,1.22E-05,1.03E-05,8.34E-06,7.06E-06,5.73E-06,4.85E-06,3.94E-06,3.07E-06,2.49E-06,2.02E-06,1.57E-06,1.28E-06,9.95E-07,7.75E-07,6.30E-07,4.90E-07,3.98E-07,3.10E-07,2.52E-07]
  d=[59.7457,59.7712,60.8238,61.8728,62.9146,62.9364,63.9745,64.0072,65.0562,66.1016,67.1433,69.1904,72.2429,73.2628,75.2808,78.2969,82.3293,82.3329,83.3746,85.4399,85.4763,86.5253,89.6032,90.6558,94.7391,96.808,99.8823,102.964,105.029,107.094,110.169,113.232,116.303,120.368,127.431,133.478,139.524,145.575,153.65,161.73,170.829,180.948,190.051,201.183,210.289,219.392,229.504,237.587,246.686,255.782,264.881,273.976,283.076,292.171,300.25,309.346,317.429,325.508,334.604,342.683,350.762,358.845,367.937,376.02,385.112,393.195]

; s2
  e=[9.75E-09,1.47E-08,2.62E-08,4.13E-08,6.77E-08,1.07E-07,1.68E-07,2.53E-07,3.99E-07,5.77E-07,8.72E-07,1.32E-06,1.90E-06,2.54E-06,3.68E-06,5.11E-06,8.39E-06,1.32E-05,2.08E-05,3.01E-05,4.74E-05,7.15E-05,0.000107997,0.000163025,0.000246196,0.000314965,0.000419391,0.000402269,0.00035454,0.000287962,0.00021554,0.000142487,9.82E-05,6.49E-05,4.66E-05,3.35E-05,2.04E-05,1.46E-05,1.09E-05,7.86E-06,5.64E-06,3.89E-06,2.91E-06,2.17E-06,1.62E-06,1.27E-06,9.46E-07,7.36E-07,5.73E-07,4.46E-07,3.78E-07,2.70E-07,2.29E-07,1.78E-07,1.39E-07,1.08E-07,8.42E-08,6.55E-08,5.11E-08,3.98E-08,2.97E-08,2.51E-08,1.80E-08,1.40E-08,1.19E-08,1.01E-08]
  f=[60.7584,60.7765,61.8146,62.8472,63.8816,65.9268,66.9594,67.9902,69.0228,71.0645,73.1079,74.1387,79.2182,82.2688,84.3104,85.3376,85.3594,86.392,88.4372,89.4662,90.4988,91.5296,93.573,95.6164,96.6472,99.696,105.785,106.795,112.866,116.907,118.92,121.94,124.961,126.968,131.004,132.003,136.031,139.055,141.067,144.091,148.127,151.148,154.174,159.224,164.275,169.327,174.377,181.455,188.532,196.623,200.666,208.753,213.809,218.861,224.926,232.003,238.068,244.133,249.186,254.238,261.314,266.37,272.431,279.509,283.552,287.595]

  oplot,a,b,linestyle=1,color=0
  oplot,c,d,linestyle=1,color=6
  oplot,e,f,linestyle=1,color=2

  device,/close
  set_plot,'x'

end