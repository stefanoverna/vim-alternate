" Alternate.vim - Find or create alternate file
" Author:      Stefano Verna <http://stefanoverna.com/>
" Version:     1.0.1

function! s:NormalFile(file, normalExt, specExt, appDirs, specDir)
  let matches = matchlist(a:file, a:specDir . '\([^/]\+\)\(.*\)$')

  if len(matches) ># 2
    let mainDir = matches[1]
    let tailPath = substitute(matches[2], a:specExt, a:normalExt, 'g')

    for rootDir in a:appDirs
      let completeDir = rootDir . mainDir

      if isdirectory(completeDir)
        return rootDir . mainDir . tailPath
      end
    endfor
  end

  return ''
endfunction

function! s:SpecFile(file, substitutions)
  for substitution in a:substitutions
    let result = matchstr(a:file, substitution[0])
    if len(result)
      let alternateFile = substitute(a:file, substitution[0], substitution[1], "g")
      return alternateFile
    end
  endfor

  return ''
endfunction

function! s:Open(file)
  if len(a:file) ># 0
    exec "e " . a:file
  end
endfunction

function! OpenAlternateFile()
  let file = expand('%')
  echom file
  if file =~# '_spec.rb$'
    call s:Open(s:NormalFile(file, '.rb', '_spec.rb', ['app/', 'lib/'], 'spec/'))
  elseif file =~# '_test.js$'
    call s:Open(s:NormalFile(file, '.js', '_test.js', ['app/scripts/'], 'test/'))
  elseif file =~# '.rb$'
    let substitutions =
      \ [
      \   [ '\vapp/(.*)\.rb', 'spec/\1_spec.rb' ],
      \   [ '\vlib/(.*)\.rb', 'spec/\1_spec.rb' ],
      \   [ '\v(.*)\.rb', 'spec/\1_spec.rb' ]
      \ ]

    call s:Open(s:SpecFile(file, substitutions))
  elseif file =~# '.js$'
    let substitutions =
      \ [
      \   [ '\vapp/scripts/(.*)\.js', 'test/\1_test.js' ],
      \   [ '\v(.*)\.js', 'test/\1_test.js' ]
      \ ]

    call s:Open(s:SpecFile(file, substitutions))
  else
    echom "No alternate found!"
  end
endfunction

" Mappings
nnoremap <silent> <leader>a :call OpenAlternateFile()<CR>

