; docformat = 'IDL'

;+
;
;Name:
;IUG_CREATE_QUERY_IONOSPHERIC_COND
;
;Purpose:
;To create query for iug_ionospheric_cond.db
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
pro iug_create_query_ionospheric_cond,height=height,glat=glat,glon=glon,yyyy=yyyy,mmdd=mmdd,ltut=ltut,atime=atime,algorithm=algorithm
  openw,unit,'/tmp/iug_ionospheric_cond_query.sql',/get_lun ; create query file
  printf,unit,'select * from iug_ionospheric_cond where height=',strtrim(string(height),1),' and glat=',strtrim(string(glat),1),' and glon=',strtrim(string(glon),1),' and yyyy=',strtrim(string(yyyy),1),' and mmdd=',strtrim(string(mmdd),1),' and ltut=',strtrim(string(ltut),1),' and atime=',strtrim(string(atime),1),' and algorithm=',strtrim(string(algorithm),1),";"
  free_lun, unit
end