let g:airline#themes#kism#palette = {}

function! airline#themes#kism#refresh()
  let s:SL = airline#themes#get_highlight('StatusLine')
  let s:SLNC = airline#themes#get_highlight('StatusLineNC')

  let s:N1   = [ "#FFFFFF", "#000000", 0, 3 ]
  let s:N2   = [ "#FFFFFF", "#000000", 0, 3 ]
  let s:N3   = [ "#FFFFFF", "#000000", 15, 8 ]

  let s:I1   = [ "#FFFFFF", "#000000", 0, 15 ]
  let s:I2   = [ "#FFFFFF", "#000000", 0, 15 ]
  let s:I3   = [ "#FFFFFF", "#000000", 15, 8 ]

  let s:V1   = [ "#FFFFFF", "#000000", 0, 13 ]
  let s:V2   = [ "#FFFFFF", "#000000", 0, 13 ]
  let s:V3   = [ "#FFFFFF", "#000000", 15, 8 ]

  let g:airline#themes#kism#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
  let g:airline#themes#kism#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
  let g:airline#themes#kism#palette.replace = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
  let g:airline#themes#kism#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
  let g:airline#themes#kism#palette.normal.airline_error   = s:SLNC
  let g:airline#themes#kism#palette.normal.airline_warning = s:SLNC
  let g:airline#themes#kism#palette.normal.airline_term    = s:SL

  let g:airline#themes#kism#palette.inactive = airline#themes#generate_color_map(s:SLNC, s:SLNC, s:SLNC)
endfunction

call airline#themes#kism#refresh()
