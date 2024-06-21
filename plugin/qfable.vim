" qfable.vim - Quickfix list tools
" Maintainer:   David Sanders <davesque@gmail.com>
" Version:      0.1

if exists("g:loaded_qfable") || &cp || v:version < 700
  finish
endif
let g:loaded_qfable = 1

function! s:GetSelection() abort
  let mode = mode()

  let [l_start, c_start] = getpos('v')[1:2]
  let [l_end, c_end] = getpos('.')[1:2]
  if mode != 'v'
    let c_start = 1
    let c_end = len(getline('.')) + 1
  endif

  if (line2byte(l_start) + c_start) > (line2byte(l_end) + c_end)
    let [l_start, c_start, l_end, c_end] = [l_end, c_end, l_start, c_start]
  endif

  return [l_start, c_start, l_end, c_end]
endfunction

function! s:AddToQf()
  let [l_start, c_start, l_end, c_end] = s:GetSelection()
  let text = trim(getline(l_start))

  let loc = {
        \ 'pattern': '',
        \ 'valid': 1,
        \ 'vcol': 0,
        \ 'nr': 0,
        \ 'module': '',
        \ 'type': ''}

  let loc['bufnr'] = bufnr('%')
  let loc['lnum'] = l_start
  let loc['end_lnum'] = l_end
  let loc['col'] = c_start
  let loc['end_col'] = c_end
  let loc['text'] = text

  let qflist = getqflist()
  copen
  call add(qflist, loc)
  call setqflist(qflist, 'r')
  clast
endfunction

nnoremap <silent> <Plug>(qfable-addtoqf) :<C-U>call <SID>AddToQf()<CR>
vnoremap <silent> <Plug>(qfable-addtoqf) :<C-U>exe 'normal! gv'<Bar>call <SID>AddToQf()<CR><Esc>

" vim:set sw=2 sts=2:
