; Docformat = 'IDL'

;+
;
;Name:
;IUG_LOAD_IONOSPHERIC_COND_MAP_HEIGHT_INTEGRATED_STEREO
;
;Purpose:
;
;Syntax:
;
;Keywords:
;
;Code:
;Yukinobu KOYAMA, 10/23/2013
;
;Modifications:
;
;
;Acknowledgment:
;
;EXAMPLE:
; IDL> thm_init
; THEMIS> iug_load_ionospheric_cond_map_height_integrated, yyyy=1987, mmdd=101, ltut=0, time=12,
; height_bottom=100, height_top=120, height_step=20, algorithm=1, 
; reso_lat=30, reso_lon=30, result=result
;-

pro iug_load_ionospheric_cond_map_height_integrated_stereo, yyyy=yyyy, mmdd=mmdd, ltut=ltut, time=time, $
                                   height_bottom=height_bottom, height_top=height_top, height_step=height_step, $
                                   algorithm=algorithm, reso_lat=reso_lat, reso_lon=reso_lon, look_at_glat=look_at_glat, look_at_glon=look_at_glon, result=result

;
  tmp_dir = '/tmp/'+string(iug_getpid(),format='(i0)')+'/'
  result_file_test = file_test(tmp_dir)
  if file_test(tmp_dir) eq 0 then begin
     file_mkdir, tmp_dir
  endif
;

; validate yyyy
  if yyyy lt 1958 and yyyy ge 2013 then begin
     dprint,"Specify yyyy in 1958 to 2012."
     return 
  endif
; validate mmdd
  if mmdd lt 101 and mmdd gt 1231 then begin
     dprint,"Specify mmdd correctly."
     return
  endif
; validate ltut
  if ltut ne 0 and ltut ne 1 then begin
     dprint,"Specify ltut correctly."
     dprint,"   0:lt, 1:ut"
     return
  endif
; validate time                                                               
  if time lt 0 and time gt 24 then begin
     dprint,"Specify time in 0 to 24."
     return
  endif
; validate height_bottom 
  if height_bottom lt 80 then begin
     dprint,"Satisfy this constraint 'height_bottom >= 80'."
;     dprint,"This procedure don't consider the cluster ion's
;     influence under the altitude of 100km."
     return
  endif
; validate height_top
  if height_top gt 2000 then begin
     dprint,"Specify height_top < 2000(km)."
     return
  endif
; validate height_step
  if height_step gt height_top-height_bottom then begin
     dprint,"Satisfy this constraint 'height_step < height_top-height_bottom'."
     return
  endif
; validate algorithm
  if algorithm ne 1 and algorithm ne 2 then begin
     dprint,"Specify algorithm correctry."
     dprint,'1: Ken-ichi Maedas, 2: by Richmonds book'
     return
  endif
; validate look_at_glat
  if look_at_glat lt -90 or look_at_glat gt 90 then begin
     dprint,"Specify -90<=look_at_glat<=90."
     return
  endif
; validate look_at_glon
if look_at_glon lt -180 or look_at_glat gt 180 then begin
     dprint,"Specify -180<=look_at_glon<=180."
     return
  endif

  if height_top ne height_bottom then begin
     num_height = (height_top-height_bottom)/height_step+1
  endif else begin
     num_height = 1
  endelse

  height_array = fltarr(num_height)

  for i=0L, num_height-1 do begin
     height_array(i) = height_bottom+height_step * 1
  endfor
;
; Calculation based on Kenichi Maeda's equation
;
  glat_array = fltarr(180/reso_lat+1)
  glon_array = fltarr(360/reso_lon+1)

  for i=0L,n_elements(glat_array)-1 do begin
     glat_array[i]=-90.+i*reso_lat
  endfor

  for i=0L,n_elements(glon_array)-1 do begin
     glon_array[i]=-180.+i*reso_lon
  endfor

  

;
;
;
  iug_load_ionospheric_cond_map, yyyy=yyyy, mmdd=mmdd, ltut=ltut, time=time, $
                                 height_bottom=height_bottom, height_top=height_top, height_step=height_step, $
                                 algorithm=algorithm, reso_lat=reso_lat, reso_lon=reso_lon, result=result

  str_height_range = string(height_bottom, format='(i4.4)')+'-'+string(height_top, format='(i4.4)')
  str_height = str_height_range

  result_table = result

;
; Just before ploting. glat=-90 and glat=90 can to work well. To stay away from it.
;
  glat_array4plot = glat_array
  glat_array4plot(0) = glat_array4plot(0) + 0.1                           ; -90 to -89
  glat_array4plot(n_elements(glat_array4plot)-1) = glat_array4plot(n_elements(glat_array4plot)-1) - 0.1 ; +90 to +89

; plotting
  for m=0L, 5 do begin          ; for sigma_0, sigma_1, sigma_2, sigma_xx, sigma_yy, sigma_xy

     if ltut eq 0 then begin
        str_ltut='LT'
     endif else begin
        str_ltut='00Z'
     endelse

     str_yyyy = string(yyyy, format='(i4.4)')
     str_mmdd = string(mmdd, format='(i4.4)')
     str_mm = strmid(str_mmdd, 0, 2)
     str_dd = strmid(str_mmdd, 2, 2)
     str_time = string(time, format='(i2.2)')

     if m eq 0 then begin
        str_title = str_yyyy+'-'+str_mm+'-'+str_dd+'T'+str_time+':'+str_ltut+', '+str_height+' km'
        str_sigma_type = 'sigma_0'
        str_ytitle = 'Height-integrated Conductivity !4R!X!L0!n (S)'
     endif else if m eq 1 then begin
        str_title = str_yyyy+'-'+str_mm+'-'+str_dd+'T'+str_time+':'+str_ltut+', '+str_height+' km'
        str_sigma_type = 'sigma_1'
        str_ytitle = 'Height-integrated Conductivity !4R!X!L1!n (S)'
     endif else if m eq 2 then begin
        str_title = str_yyyy+'-'+str_mm+'-'+str_dd+'T'+str_time+':'+str_ltut+', '+str_height+' km'
        str_sigma_type = 'sigma_2'
        str_ytitle = 'Height-integrated Conductivity !4R!X!L2!n (S)'
     endif else if m eq 3 then begin
        str_title = str_yyyy+'-'+str_mm+'-'+str_dd+'T'+str_time+':'+str_ltut+', '+str_height+' km'
        str_sigma_type = 'sigma_xx'
        str_ytitle = 'Height Integrated Ionospheric Conductivity !4r!X!Lxx!n (S)'
     endif else if m eq 4 then begin
        str_title = str_yyyy+'-'+str_mm+'-'+str_dd+'T'+str_time+':'+str_ltut+', '+str_height+' km'
        str_sigma_type = 'sigma_yy'
        str_ytitle = 'Height Integrated Ionospheric Conductivity !4r!X!Lyy!n (S)'
     endif else if m eq 5 then begin
        str_title = str_yyyy+'-'+str_mm+'-'+str_dd+'T'+str_time+':'+str_ltut+', '+str_height+' km'
        str_sigma_type = 'sigma_xy'
        str_ytitle = 'Height Integrated Ionospheric Conductivity !4r!X!Lxy!n (S)'
     endif

     result_plot_height_integrated = fltarr(n_elements(glon_array), n_elements(glat_array))

     for i=0L, n_elements(height_array)-1 do begin

        result_plot = fltarr(n_elements(glon_array), n_elements(glat_array))

        cnt = n_elements(result_table)

        for j=0L, cnt-1 do begin
           for k=0L, n_elements(glat_array)-1 do begin
              for l=0L, n_elements(glon_array)-1 do begin
                 if result_table[j].height eq height_array(i) $
                    and result_table[j].glat eq glat_array[k] $
                    and result_table[j].glon eq glon_array[l] then begin

                    if m eq 0 then begin
                       result_plot(l,k) = result_table[j].sigma_0
                    endif else if m eq 1 then begin
                       result_plot(l,k) = result_table[j].sigma_1
                    endif else if m eq 2 then begin
                       result_plot(l,k) = result_table[j].sigma_2
                    endif else if m eq 3 then begin
                       result_plot(l,k) = result_table[j].sigma_xx
                    endif else if m eq 4 then begin
                       result_plot(l,k) = result_table[j].sigma_yy
                    endif else if m eq 5 then begin
                       result_plot(l,k) = result_table[j].sigma_xy
                    endif 
                 endif
              endfor
           endfor
        endfor

        if i gt 0 then begin
           result_plot_height_integrated = result_plot_height_integrated $
                                           + (result_plot + result_plot_lower) /2. * height_step * 1.E3
        endif

        result_plot_lower = result_plot
     endfor

;
     set_plot, 'ps'

     set_resolution=[1024,768]
     device, filename=tmp_dir+'ionospheric_cond_map_'+str_yyyy+'-'+str_mm+'-'+str_dd+'T'+str_time+'_'+str_ltut+'_'+str_height+'_'+str_sigma_type+'.eps', /color, /encapsulated, xsize=11

     map_set, /STEREO, look_at_glat, look_at_glon, /ISOTROPIC, /HORIZON, E_HORIZON={FILL:0}, TITLE=str_title, position=[0.0,0.1,0.8,0.9]

     nlevels = 100
     loadct, 33, ncolors=nlevels, bottom=1
     transparency = 50

     contour, alog10(result_plot_height_integrated), glon_array, $
              glat_array4plot, /overplot, /cell_fill, nlevels=nlevels, $
              c_colors=indgen(nlevels), position=[0.0,0.0,0.93,0.93], $
              zrange=[alog10(1e+0), alog10(1e+4)]
     colorbar, bottom=1, divisions=4, ncolors=nlevels, position=[0.1, 0.79, 0.90, 0.81], format='(e8.1)', range=[alog10(1e+1), alog10(1e+5)], right='right', vertical='vertical',ticknames=['1e+1','1e+2','1e+3','1e+4','1e+5'], title=str_ytitle
     lats = [-90,-75,-60,-45,-30,-15,0,15,30,45,60,75,90]
     latnames = ['','','60'+string(176b)+'S','45'+string(176b)+'S','30'+string(176b)+'S','15'+string(176b)+'S','0'+string(176b),'15'+string(176b)+'N','30'+string(176b)+'N','45'+string(176b)+'N','60'+string(176b)+'N','','']
     lons = [-180,-120,-60,0,60,120,180]
     lonnames = ['','120'+string(176b)+'W','60'+string(176b)+'W','0'+string(176b),'60'+string(176b)+'E','120'+string(176b)+'E','']
     map_grid, latdel=15, londel=30, color=0, charsize=1.0, lats=lats, lons=lons, label=1, latnames=latnames, lonnames=lonnames, lonalign=-0.5
     map_continents, /STEREOGRAPHIC, /ORTHOGRAPHIC

;
     xyouts, 0, 0, '0'+string(176b), color=0
     xyouts, -60, 0, '60'+string(176b)+'W', color=0
     xyouts, 60, 0, '60'+string(176b)+'E', color=0
;
     device, /close
     set_plot, 'x'
; txt
     openw, unit, tmp_dir+'ionospheric_cond_map_'+str_yyyy+'-'+str_mm+'-'+str_dd+'T'+str_time+'_'+str_ltut+'_'+str_height+'_'+str_sigma_type+'.txt', /get_lun
     printf, unit, result_plot_height_integrated, format='(e8.1)'
     printf, unit, "GLON_ARRAY=",glon_array
     printf, unit, "GLAT_ARRAY=",glat_array
     free_lun, unit

     print, max(result_plot)

  endfor
end
