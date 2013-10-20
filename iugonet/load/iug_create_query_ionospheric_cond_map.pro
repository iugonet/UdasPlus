; docformat = 'IDL'

;+
;
;Name:
;IUG_CREATE_QUERY_IONOSPHERIC_COND
;
;Purpose:
;To create query for ionospheric_cond.db
;
;Keywords:
;
;Code:
;Yukinobu KOYAMA, 10/01/2013
;
;Acknowledgment:
;
;EXAMPLE:
;  iug_create_query_ionospheric_cond,1,2000,0,0,100
;-
pro iug_create_query_ionospheric_cond_map,height_bottom=height_bottom, heigit_top=height_top, height_step=height_step, resolution=resolution, yyyy=yyyy, mmdd=mmdd, ltut=ltut, time=time, algorithm=algorithm
;
  if height_top ne height_bottom then begin
     num_height = (height_top-height_bottom)/height_step+1
  endif else begin
     num_height =1
  endelse

  height_array=fltarr(num_height)
  
  for i=0L,num_height-1 do begin
     height_array(i)=height_bottom+height_step*i
  endfor
;
  glat_list=fltarr(180/resolution+1)
  glon_list=fltarr(360/resolution+1)

  for i=0L,n_elements(glat_list)-1 do begin
     glat_list[i]=-90.+i*resolution
  endfor

  for i=0L,n_elements(glon_list)-1 do begin
     glon_list[i]=-180.+i*resolution
  endfor
;
  openw,unit,'/tmp/ionospheric_cond_map_query.sql',/get_lun ; create query file

  for i=0L,n_elements(glat_list)-1  do begin
     for j=0L,n_elements(glon_list)-1 do begin
        for k=0L,num_height-1 do begin
           printf,unit,'select * from ionospheric_cond where height=',strtrim(string(height_array(k)),1),' and glat=',strtrim(string(glat_list[i]),1),' and glon=',strtrim(string(glon_list[j]),1),' and yyyy=',strtrim(string(yyyy),1),' and mmdd=',strtrim(string(mmdd),1),' and ltut=',strtrim(string(ltut),1),' and atime=',strtrim(string(time),1),' and algorithm=',strtrim(string(algorithm),1),";"
        endfor
     endfor
  endfor

  free_lun, unit
end
