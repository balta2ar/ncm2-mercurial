if get(s:, 'loaded', 0)
    finish
endif
let s:loaded = 1

let g:ncm2_mercurial_enabled = get(g:, 'ncm2_mercurial_enabled',  1)

let g:ncm2_mercurial#proc = yarp#py3('ncm2_mercurial')

let g:ncm2_mercurial#source = get(g:, 'ncm2_mercurial#mercurial_source', {
            \ 'name': 'mercurial',
            \ 'priority': 9,
            \ 'mark': 'HG',
            \ 'word_pattern': 'HG\w*',
            \ 'complete_pattern': 'HG\w*',
            \ 'matcher': {'key': 'custom'},
            \ 'on_complete': 'ncm2_mercurial#on_complete',
            \ 'on_warmup': 'ncm2_mercurial#on_warmup'
            \ })

let g:ncm2_mercurial#source = extend(g:ncm2_mercurial#source,
            \ get(g:, 'ncm2_mercurial#source_override', {}),
            \ 'force')

function! ncm2_mercurial#init()
    call ncm2#register_source(g:ncm2_mercurial#source)
endfunction

function! ncm2_mercurial#on_warmup(ctx)
    call g:ncm2_mercurial#proc.jobstart()
endfunction

function! ncm2_mercurial#on_complete(ctx)
    let s:is_enabled = get(b:, 'ncm2_mercurial_enabled',
                \ get(g:, 'ncm2_mercurial_enabled', 1))
    if ! s:is_enabled
        return
    endif
    call g:ncm2_mercurial#proc.try_notify('on_complete', a:ctx)
endfunction


function! ncm2_mercurial#toggle(scope)
    let s:ncm2_mercurial = {}
    let s:ncm2_mercurial['global'] = get(g:, 'ncm2_mercurial_enabled', 1)
    let s:ncm2_mercurial['buffer'] = get(b:, 'ncm2_mercurial_enabled', s:ncm2_mercurial['global'])
    if (s:ncm2_mercurial[a:scope] == 1)
        let s:ncm2_mercurial[a:scope]=0
    else
        let s:ncm2_mercurial[a:scope]=1
    endif
    let g:ncm2_mercurial_enabled=s:ncm2_mercurial['global']
    let b:ncm2_mercurial_enabled=s:ncm2_mercurial['buffer']
endfunction
