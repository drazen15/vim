" vim: set ts=4 sw=4 tw=78 noet :
"======================================================================
"
" utils.vim - utils
"
" Created by skywind on 2022/12/24
" Last Modified: 2022/12/24 03:38:40
"
"======================================================================


"----------------------------------------------------------------------
" internal
"----------------------------------------------------------------------


"----------------------------------------------------------------------
" internal save view
"----------------------------------------------------------------------
function! s:save_view(mode)
	if a:mode == 0
		let w:starter_save = winsaveview()
	else
		if exists('w:starter_save')
			if get(b:, 'starter_keep', 0) == 0
				call winrestview(w:starter_save)
			endif
			unlet w:starter_save
		endif
	endif
endfunc


"----------------------------------------------------------------------
" save view
"----------------------------------------------------------------------
function! starter#utils#save_view() abort
	let winid = winnr()
	keepalt noautocmd windo call s:save_view(0)
	keepalt noautocmd silent! exec printf('%dwincmd w', winid)
endfunc


"----------------------------------------------------------------------
" restore view
"----------------------------------------------------------------------
function! starter#utils#restore_view() abort
	let winid = winnr()
	keepalt noautocmd windo call s:save_view(1)
	keepalt noautocmd silent! exec printf('%dwincmd w', winid)
endfunc


"----------------------------------------------------------------------
" create a new buffer
"----------------------------------------------------------------------
function! starter#utils#create_buffer() abort
	if has('nvim') == 0
		let bid = bufadd('')
		call bufload(bid)
		call setbufvar(bid, '&buflisted', 0)
		call setbufvar(bid, '&bufhidden', 'hide')
	else
		let bid = nvim_create_buf(v:false, v:true)
	endif
	call setbufvar(bid, '&modifiable', 1)
	call deletebufline(bid, 1, '$')
	call setbufvar(bid, '&modified', 0)
	call setbufvar(bid, '&filetype', '')
	return bid
endfunc


"----------------------------------------------------------------------
" update buffer content
"----------------------------------------------------------------------
function! starter#utils#update_buffer(bid, textlist) abort
	if type(a:textlist) == v:t_list
		let textlist = a:textlist
	else
		let textlist = split('' . a:textlist, '\n', 1)
	endif
	let old = getbufvar(a:bid, '&modifiable', 0)
	call setbufvar(a:bid, '&modifiable', 1)
	call deletebufline(a:bid, 1, '$')
	call setbufline(a:bid, 1, textlist)
	call setbufvar(a:bid, '&modified', old)
endfunc


"----------------------------------------------------------------------
" resize window
"----------------------------------------------------------------------
function! starter#utils#window_resize(wid, width, height) abort
	let wid = (a:wid <= 0)? winnr() : a:wid
	call starter#utils#save_view()
	if a:width >= 0
		exec printf('vert %dresize %d', wid, a:width)
	endif
	if a:height >= 0
		exec printf('%dresize %d', wid, a:height)
	endif
	call starter#utils#restore_view()
endfunc


