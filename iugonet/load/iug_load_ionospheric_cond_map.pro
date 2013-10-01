; docformat = 'IDL'

;+
;
;Name:
;IUG_LOAD_IONOSPHERIC_COND_MAP
;
;Purpose:
;
;Syntax:
;
;Keywords:
;
;Code:
;Yukinobu KOYAMA, 05/05/2012
;
;Modifications:
;
;Acknowledgment:
;
;EXAMPLE:
; IDL> thm_init
; THEMIS> iug_load_ionospheric_cond_map, yyyy=1987, mmdd=101, ltut=0, time=12,
; height_bottom=100, height_top=120, height_step=20, algorithm=1, 
; resolution=30, result=result
;-

pro iug_load_ionospheric_cond_map, yyyy=yyyy, mmdd=mmdd, ltut=ltut, time=time, height_bottom=height_bottom, height_top=height_top, height_step=height_step, algorithm=algorithm, resolution=resolution, result=result

; validate yyyy
  if yyyy lt 1958 and yyyy ge 2013 then begin
     dprint,"Specify yyyy in 1958 to 2012."
     return 
  endif

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
  result = fltarr(7,num_height)
  result2 = fltarr(360./resolution,180./resolution,6,num_height)

;  set_plot,'ps'
;  device,filename='iug_load_ionospheric_cond_map.eps',/color,/encapsulated

  glat_list=fltarr(180./resolution+1)
  glon_list=fltarr(360./resolution+1)

  print,n_elements(glat_list)
  print,n_elements(glon_list)

  for i=0L,n_elements(glat_list)-1 do begin
     glat_list[i]=-90+i*resolution
  endfor
  print,n_elements(glat_list)
  print,n_elements(glon_list)

  for i=0L,n_elements(glon_list)-1 do begin
     glon_list[i]=-180+i*resolution
  endfor
;
;
;
  for i=0L,n_elements(glon_list)-1 do begin
     for j=0L,n_elements(glat_list)-1  do begin
        for k=0L,num_height-1 do begin
           iug_load_ionospheric_cond, height_bottom=height_bottom, height_top=height_top, height_step=height_step, glat=glat_list[j], glon=glon_list[i], yyyy=yyyy, mmdd=mmdd, ltut=ltut, time=time, algorithm=algorithm, result=result
           result2[i,j,k]=result
        endfor
     endfor
  endfor

  map_set, /CYLINDRICAL, 0, 0, /GRID, /CONTINENTS, $  
   TITLE = 'World map of Ionospheric Conductivity'
;  plot,result[0,*],result[6,*],xtitle="Conductivities (S/m)", $
;       ytitle="Altitude (km)",yrange=[0,400],xrange=[1E-8,1E2],/xlog, $
;       linestyle=0,color=0, title="GLAT=44.6, GLON=2.2, Solar Minimum conditions on March 21"
;  oplot, result[1,*],result[6,*],linestyle=0,color=6
;  oplot, result[2,*],result[6,*],linestyle=0,color=2
;  xyouts, 135, 35, 'Japan', ALIGNMENT=0.5, color=6
  print,result2
  result3 = fltarr(360./resolution+1,180./resolution+1)
  for i=0L,n_elements(glon_list)-1 do begin
     for j=0L,n_elements(glat_list)-1 do begin
        result3[i,j]=100*i+10*j
     endfor
  endfor
  print,"result3=",result3
;  map_set, /stereo, 90, 0, /ISOTROPIC, /HORIZON, E_HORIZON={FILL:1},$
;  title='World Map of Ionospheric Conductivity'
;  CONTOUR, result3, glon_list, glat_list, $
;           /OVERPLOT,/FILL,LEVELS=10,c_colors=[1,2]
;  CONTOUR, result3, glon_list,glat_list,/OVERPLOT,/FILL,LEVELS=1
  contour, result3, /OVERPLOT, LEVELS=2
;  map_grid, latdel=10, londel=10, color=255
;  set_plot,'x'

end