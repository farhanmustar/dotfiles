if !executable('curl')
  finish
endif

" Refer this list for more...
" https://github.com/chubin/awesome-console-services

function! s:TempTerm(cmd)
  silent execute 'term ' . a:cmd . ' && exit 1'
  setlocal bufhidden=delete nobuflisted
endfunction

" Vim Tips
" Exp:
" :Vimtip
command! -nargs=0 Vimtip split | call <SID>TempTerm('curl -s "https://vtip.43z.one/"')

" Weather forcast
" Exp:
" :Weather johor
command! -nargs=* Weather tabnew | call <SID>TempTerm('curl -s "wttr.in/<args>"')

" QRcode
" Exp:
" :QREncode message in qr
command! -nargs=+ QREncode tabnew | call <SID>TempTerm('curl -s "qrenco.de/<args>"')

" Gif
" Exp:
" :Gif noooo
command! -nargs=+ Gif silent execute 'tabnew | term curl -s "gif.xyzzy.run/<args>"'
command! GifMagic silent execute 'tabnew | term curl -s "gif.xyzzy.run/spongebobmagical"'

" Dictionary search
" Exp:
" :Dictionary food
" :Dictionary food:all
" :Dictionary food:fd-eng-afr
command! -nargs=+ Dictionary tabnew | call <SID>TempTerm('curl -s dict.org/d:<args>')
command! DictionaryList tabnew | call <SID>TempTerm('curl -s dict://dict.org/show:db')

" Waktu Solat
" API from https://e-solat.gov.my
let s:WaktuSolatDefaultZone = 'SGR01'
let s:WaktuSolatZoneList = ['JHR02', 'SGR01', 'NGS03']
function <SID>WaktuSolatComplete(A,L,P)
    let l = copy(get(s:, 'WaktuSolatZoneList', []))
    call filter(l, 'v:val =~ "^'.a:A.'"')
    return l
endfun
command! -nargs=? -complete=customlist,<SID>WaktuSolatComplete WaktuSolat call WaktuSolatGet(<q-args>)
" command! WaktuSolatZon call WaktuSolatGetZone()

function! WaktuSolatGet (zon) abort
  let zon = empty(a:zon) ? s:WaktuSolatDefaultZone : a:zon
  " Get zone data
  let response = system('curl -sk -G -L "https://www.e-solat.gov.my/index.php?r=esolatApi/zone&zone='.zon.'"')
  let zone = json_decode(response)
  let response = system('curl -sk -G -L "https://www.e-solat.gov.my/index.php?r=esolatApi/takwimsolat&period=today&zone='.zon.'"')
  let data = json_decode(response)

  let imsak = split(data['prayerTime']['0']['imsak'], ':')
  let fajr = split(data['prayerTime']['0']['fajr'], ':')
  let syuruk = split(data['prayerTime']['0']['syuruk'], ':')
  let dhuhr = split(data['prayerTime']['0']['dhuhr'], ':')
  let asr = split(data['prayerTime']['0']['asr'], ':')
  let maghrib = split(data['prayerTime']['0']['maghrib'], ':')
  let isha = split(data['prayerTime']['0']['isha'], ':')

  echo ' '
  echo ' '
  echo 'Waktu Solat (e-solat.gov.my)'
  echo 'Kawasan : '.zone['zoneData'].' ['.data['zone'].']'
  echo 'Tarikh  : '.data['prayerTime']['0']['date']
  echo 'Hijrah  : '.data['prayerTime']['0']['hijri']
  echo 'Hari    : '.data['prayerTime']['0']['day']
  echo ' '
  echo 'Imsak   : '.s:FormatTime(data['prayerTime']['0']['imsak'])
  echo 'Subuh   : '.s:FormatTime(data['prayerTime']['0']['fajr'])
  echo 'Syuruk  : '.s:FormatTime(data['prayerTime']['0']['syuruk'])
  echo 'Zohor   : '.s:FormatTime(data['prayerTime']['0']['dhuhr'])
  echo 'Asar    : '.s:FormatTime(data['prayerTime']['0']['asr'])
  echo 'Maghrib : '.s:FormatTime(data['prayerTime']['0']['maghrib'])
  echo 'Isyak   : '.s:FormatTime(data['prayerTime']['0']['isha'])
  echo ' '
endfunction

function! s:FormatTime(time) abort
  let [h, m, s] = split(a:time, ':')
  let p =  h >= 12  && h < 24 ? 'pm' : 'am'
  let h = h > 12 ? printf('%02d', h - 12) : h

  return h.':'.m.' '.p
endfunction
