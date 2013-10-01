; docformat = 'IDL'

;+
;
;Name: IUG_LOAD_IRI2012
;
;INPUTS:
;yyyy: year
;
;Purpose:
;
;Syntax:
;
;KEYWORD PARAMETERS:
;hoge:
;
;Code: Yukinobu KOYAMA, 4/25/2012
;
;Modifications:
;
;Acknowledgment:
;
;Example:
;   iug_load_iri2012,yyyy=2000,mmdd=101,ltut=0,time=12,glat=0,glon=0,height_bottom=100,height_top=120,height_step=10,result=result
;
;-

pro iug_load_iri2012,yyyy=yyyy,mmdd=mmdd,ltut=ltut,time=time,glat=glat,glon=glon,height_bottom=height_bottom,height_top=height_top,height_step=height_step,result=result

  if height_top ne height_bottom then begin
     num_height = (height_top-height_bottom)/height_step+1
  endif else begin
     num_height = 1 
     height_step = 1 ; height_step=1 is just dummy to execute iri2012. 
  endelse

  openw,unit,'/tmp/input_iri2012.txt',/get_lun ; create input file
  printf,unit,0,glat,glon
  printf,unit,yyyy,mmdd,ltut,time
  printf,unit,0
  printf,unit,0
  printf,unit,0
  printf,unit,1
  printf,unit,height_bottom,height_top,height_step
  printf,unit,0
  printf,unit,0
  free_lun, unit

  spawn,'cd ${HOME}/models/ionospheric/iri/iri2012;./iritest < /tmp/input_iri2012.txt'
  spawn,"cat ${HOME}/models/ionospheric/iri/iri2012/fort.7 | awk '{if( NR>27 ) print $0}' > /tmp/tmp.txt"

  result = fltarr(15,num_height)

  openr, unit, '/tmp/tmp.txt', /GET_LUN
  temp0='' & temp1='' & temp2='' & temp3='' & temp4='' 
  temp5='' & temp6='' & temp7='' & temp8='' & temp9='' 
  temp10='' & temp11='' & temp12='' & temp13='' & temp14=''

  for i=0L,num_height-1 do begin
     readf,unit,format='(a6,a8,a7,a6,a6,a6,a4,a4,a4,a4,a4,a4,a4,a6,a4)',temp0,temp1,temp2,temp3,temp4,temp5,temp6,temp7,temp8,temp9,temp10,temp11,temp12,temp13,temp14

     result[0,i]=temp0 ; alt
     result[1,i]=temp1 ; Ne/cm-3
     result[2,i]=temp2 ; Ne/NmF2
     result[3,i]=temp3 ; Tn/K
     result[4,i]=temp4 ; Ti/K
     result[5,i]=temp5 ; Te/K
     result[6,i]=temp6 ; O+
     result[7,i]=temp7 ; N+
     result[8,i]=temp8 ; H+
     result[9,i]=temp9 ; He+
     result[10,i]=temp10 ; O2+
     result[11,i]=temp11 ; NO+
     result[12,i]=temp12 ; Clust
     result[13,i]=temp13 ; TEC
     result[14,i]=temp14 ; t/%
  endfor

  free_lun, unit

end