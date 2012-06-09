if version < 700 || exists("b:LFiler_syntax")
  finish
endif

"syn match LfilerInfo   /^[0-9\/]\{10\}  [0-9:]\{5\} *[0-9,]*/
syn match LfilerInfoA  /^[0-9\/]\{10\}  */
syn match LfilerInfoB  /[0-9:]\{5\} */
syn match LfilerInfoC  /[0-9,]* /
syn match LfilerDir    /<DIR>.*/
syn match LfilerSym    /<SYMLINKD*/
syn match LfilerExt1   /\(\<exe$\|\<EXE$\|\<o$\|\<xml$\|\<doc$\|\<lzh$\|\<7z$\|\<jpg$\|\<lzma$\|\<vcproj$\)/
syn match LfilerExt2   /\(\<dll$\|\<DLL$\|\<h$\|\<php$\|\<xls$\|\<zip$\|\<gz$\|\<tif$\|\<html$\|\<class$\)/
syn match LfilerExt3   /\(\<obj$\|\<OBJ$\|\<C$\|\<XML$\|\<pdf$\|\<cab$\|\<pl$\|\<png$\|\<xaml$\|\<sln$\)/
syn match LfilerExt4   /\(\<cpp$\|\<CPP$\|\<c$\|\<ini$\|\<psd$\|\<tar$\|\<ps$\|\<bmp$\|\<java$\|\<txt$\)/
syn match LfilerExt5   /\(\<lnk$\|\<LNK$\|\<O$\|\<def$\|\<dws$\|\<bat$\|\<cc$\|\<ras$\|\<HTML$\)/
syn match LfilerExt6   /\(\<sys$\|\<SYS$\|\<H$\|\<log$\|\<DOC$\|\<vim$\|\<CC$\|\<gif$\|\<XML$\)/
syn match LfilerPath   /[a-zA-Z]:\\.*\\/
syn match LfilerUnc    /\\\\.*\\/
syn match LfilerYTitle '<< yanked files >>'
syn match LfilerFTitle '<< find files >>'
syn match LfilerCTitle '<< command >>'
syn match LfilerBTitle '<< bookmark files >>'
syn match LfilerMTitle '<< mru files >>'
syn match LfilerHeader /^.* のディレクトリ.*$/
syn match LfilerCont   /^sort=.*$/
syn match LfilerInfo1  /^.*個のファイル.* バイト$/
syn match LfilerInfo2  /^.*個のディレクトリ.* バイトの空き領域$/
syn match LfilerSort   /\(\<name$\|\<size$\|\<time$\|\<extension$\)/
syn match LfilerSelect /^.*\*.*$/

"if exists('g:colors_name') && g:colors_name == "neon"
if 0
hi LfilerInfoA  guibg=#000505 guifg=#5060FF gui=none
hi LfilerInfoB  guibg=#001010 guifg=#7090FF gui=none
hi LfilerInfoC  guibg=#001515 guifg=#90A0FF gui=none
hi LfilerDir    guibg=#001515 guifg=#5080F0 gui=none
hi LfilerSym    guibg=#050560 guifg=#9090FF gui=none
hi LfilerExt1   guibg=#000000 guifg=#FF0000 gui=none
hi LfilerExt2   guibg=#000000 guifg=#00FF00 gui=none
hi LfilerExt3   guibg=#000000 guifg=#0080FF gui=none
hi LfilerExt4   guibg=#000000 guifg=#FFFF00 gui=none
hi LfilerExt5   guibg=#000000 guifg=#008000 gui=none
hi LfilerExt6   guibg=#000000 guifg=#00FFFF gui=none
hi LfilerPath   guibg=#000000 guifg=#6688AA gui=none
hi LfilerUnc    guibg=#000000 guifg=#6688AA gui=none
hi LfilerYTitle guibg=#000000 guifg=#6699FF gui=underline
hi LfilerFTitle guibg=#000000 guifg=#6699FF gui=underline
hi LfilerCTitle guibg=#000000 guifg=#6699FF gui=underline
hi LfilerBTitle guibg=#000000 guifg=#6699FF gui=underline
hi LfilerMTitle guibg=#000000 guifg=#6699FF gui=underline
hi LfilerHeader guibg=#004080 guifg=#B0D0FF gui=none
hi LfilerCont   guibg=#000030 guifg=#EEEEEE gui=none
hi LfilerInfo1  guibg=#000000 guifg=#666666 gui=none
hi LfilerInfo2  guibg=#000000 guifg=#666666 gui=none
hi LfilerSort   guibg=#000000 guifg=#80EEEE
else
hi link LfilerInfoA   Keyword
hi link LfilerInfoB   Type
hi link LfilerInfoC   PreProc
hi link LfilerDir     Directory
hi link LfilerSym     String
hi link LfilerExt1    Number
hi link LfilerExt2    Boolean
hi link LfilerExt3
hi link LfilerExt4
hi link LfilerExt5
hi link LfilerExt6
hi link LfilerPath    Comment
hi link LfilerUnc     Comment
hi link LfilerYTitle  Title
hi link LfilerFTitle  Title
hi link LfilerCTitle  Title
hi link LfilerBTitle  Title
hi link LfilerMTitle  Title
hi link LfilerHeader  Title
hi link LfilerCont    Repeat
hi link LfilerInfo1   Define
hi link LfilerInfo2   Macro
hi link LfilerSort    Statement
endif
hi LfilerSelect               guifg=#0000FF gui=bold

let b:LFiler_syntax = 1
