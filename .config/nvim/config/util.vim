" store and then execute the command.
function! CMD(command)
  call histadd(':', a:command)
  execute a:command
endfunction

function RepeatStr(number, string)
  let result = ''
  for i in range(a:number)
    let result .= a:string
  endfor
  return result
endfunction

function VCountStr()
  let l:count = get(v:, 'count')
  return l:count == 0 ? '': l:count
endfunction

function! AddHighlightWithTimeout(group, pos, timeout)
    let match_id = matchaddpos(a:group, a:pos)
    
    call timer_start(a:timeout, {-> matchdelete(match_id)})
endfunction
