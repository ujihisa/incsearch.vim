scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" Improved backward word detection which ignore regular expression
let s:module = {
\	"name" : "IgnoreRegexpBackwardWord"
\}

function! s:backward_word(str, ...)
	let pat = get(a:, 1, '\k\+\s*\|.')
	let flags = s:non_escaped_backslash .
	\   '\%(' . 'z[se]' .
	\   '\|' . '[iIkKfFpPsSdDxXoOwWhHaAlLuUetrbncCZmMvV]' .
	\   '\|' . '%[dxouUCVlcv]' .
	\   '\|' . "%'[a-Z]" .
	\   '\|' . '%#=\d' .
	\   '\|' . 'z\=\d' .
	\   '\)'
	return matchstr(get(split(a:str, flags . '\s*\zs'), -1, ""),
	\   '\%(' . flags . '\s*\|' . pat . '\)$')
endfunction


let s:non_escaped_backslash = '\m\%(\%(^\|[^\\]\)\%(\\\\\)*\)\@<=\\'

function! s:module.on_enter(cmdline)
	function! a:cmdline.backward_word(...)
		return call("s:backward_word", [self.backward()] + a:000)
	endfunction
endfunction

function! s:make()
	return deepcopy(s:module)
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo