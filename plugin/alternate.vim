" Alternate.vim - Find or create alternate file
" Author:      Stefano Verna <http://stefanoverna.com/>
" Version:     1.0.1

function! s:NormalFile(file)
  echo a:file
  let matches = matchlist(a:file, 'spec/\([^/]\+\)\(.*\)$')

  if len(matches) ># 2
    let mainDir = matches[1]
    let tailPath = substitute(matches[2], '_spec.rb', '.rb', 'g')

    let rootDirs = [ 'app/', 'lib/' ]
    for rootDir in rootDirs
      let completeDir = rootDir . mainDir

      if isdirectory(completeDir)
        return rootDir . mainDir . tailPath
      end
    endfor
  end

  return ''
endfunction

function! s:SpecFile(file)
  let substitutions =
    \ [
    \   [ '\vapp/(.*)\.rb', 'spec/\1_spec.rb' ],
    \   [ '\vlib/(.*)\.rb', 'spec/\1_spec.rb' ],
    \   [ '\v(.*)\.rb', 'spec/\1_spec.rb' ]
    \ ]

  for substitution in substitutions
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
  if file =~# '_spec.rb$'
    call s:Open(s:NormalFile(file))
  elseif file =~# '.rb$'
    call s:Open(s:SpecFile(file))
  else
    echom "No alternate found!"
  end
endfunction

" Mappings
nnoremap <silent> <leader>a :call OpenAlternateFile()<CR>

