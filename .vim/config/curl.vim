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
" API from https://api.azanpro.com
let s:WaktuSolatDefaultZone = 'JHR02'
command! -nargs=? WaktuSolat call WaktuSolatGet(<q-args>)
command! WaktuSolatZon call WaktuSolatGetZone()

function! WaktuSolatGet (zon) abort
  let zon = empty(a:zon) ? s:WaktuSolatDefaultZone : a:zon
  let response = system('curl -s -G -L "api.azanpro.com/times/today.json" --data-urlencode "format=12-hour" --data-urlencode "zone='.zon.'"')
  let data = json_decode(response)
  echo ' '
  echo ' '
  echo 'Waktu Solat (api.azanpro.com)'
  echo 'Kawasan : ['.data['zone'].'] '.join(data['locations'], ', ')
  echo 'Tarikh  : '.data['prayer_times']['date']
  echo ' '
  echo 'Imsak   : '.data['prayer_times']['imsak']
  echo 'Subuh   : '.data['prayer_times']['subuh']
  echo 'Syuruk  : '.data['prayer_times']['syuruk']
  echo 'Zohor   : '.data['prayer_times']['zohor']
  echo 'Asar    : '.data['prayer_times']['asar']
  echo 'Maghrib : '.data['prayer_times']['maghrib']
  echo 'Isyak   : '.data['prayer_times']['isyak']
  echo ' '
endfunction
function! WaktuSolatGetZone () abort
  let response = system('curl -s -L "api.azanpro.com/zone/grouped.json"')
  let data = json_decode(response)
  echo ' '
  echo ' '
  echo 'Senarai Zon'
  echo ' '
  for entry in data['results']
    echo entry['zone'].'    '.entry['negeri'].'    '.entry['lokasi']
  endfor
  echo ' '
  echo ' '
endfunction
