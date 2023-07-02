" store and then execute the command.
function! CMD(command)
  call histadd(':', a:command)
  execute a:command
endfunction
