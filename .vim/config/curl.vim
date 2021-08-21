if !executable('curl')
  finish
endif

" Refer this list for more...
" https://github.com/chubin/awesome-console-services

" Weather forcast
" Exp:
" :Weather johor
command! -nargs=* Weather silent execute '!curl -s "wttr.in/<args>"'| echo ' ' | echo ' ' | execute '!' | redraw!

" QRcode
" Exp:
" :QREncode message in qr
command! -nargs=+ QREncode silent execute '!curl -s "qrenco.de/<args>"' | echo ' ' | echo ' ' | execute '!' | redraw!

" Gif
" Exp:
" :Gif noooo
command! -nargs=+ Gif silent execute '!curl -s "e.xec.sh/<args>"' | redraw!
command! GifMagic silent execute '!curl -s "e.xec.sh/spongebobrainbowmagic"' | redraw!
command! GifStarwarsMovie silent execute '!curl -s "https://asciitv.fr"' | redraw!

" Covid
" Exp:
" :Covid
" :Covid malaysia
command! -nargs=? Covid silent execute '!curl -s -L covid19.trackercli.com/<args>' | echo ' ' | echo ' ' | execute '!' | redraw!

" Dictionary search
" Exp:
" :Dictionary food
" :Dictionary food:all
" :Dictionary food:fd-eng-afr
command! -nargs=+ Dictionary silent execute '!curl dict.org/d:<args>' | echo ' ' | echo ' ' | execute '!' | redraw!
command! DictionaryList silent execute '!curl dict://dict.org/show:db' | echo ' ' | echo ' ' | execute '!' | redraw!

" Waktu Solat
" API from https://waktu-solat-api.herokuapp.com/api/v1/prayer_times
" by Zaim Ramlan (https://github.com/zaimramlan/waktu-solat-api)
let s:WaktuSolatDefaultZone = 'johor bharu'
command! -nargs=? WaktuSolat call WaktuSolatGet(<q-args>)
command! WaktuSolatZon call WaktuSolatGetZone()

function! WaktuSolatGet (zon) abort
  let zon = empty(a:zon) ? s:WaktuSolatDefaultZone : a:zon
  let response = system('curl -s -G "waktu-solat-api.herokuapp.com/api/v1/prayer_times" --data-urlencode "zon='.zon.'"')
  let data = json_decode(response)
  echo ' '
  echo ' '
  echo 'Waktu Solat ('.data['about']['source'].')'
  echo 'Negeri : '.data['data'][0]['negeri'].'    Zon : '.data['data'][0]['zon']
  echo ' '
  for entry in data['data'][0]['waktu_solat']
    echo entry['name'].'    '.entry['time']
  endfor
  echo ' '
endfunction
function! WaktuSolatGetZone () abort
  let response = system('curl -s "waktu-solat-api.herokuapp.com/api/v1/zones"')
  let data = json_decode(response)
  echo ' '
  echo ' '
  echo 'Senarai Zon'
  echo ' '
  for entry in data['data']['zon']
    echo entry
  endfor
  echo ' '
  echo ' '
endfunction
