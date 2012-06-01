if version < 700 || exists("b:LFiler_syntax")
  finish
endif

syn match LfilerInfo   /^[0-9\/]\{10\}  [0-9:]\{5\} *[0-9,]*/
syn match LfilerDir    /.*\<DIR\>.*/
syn match LfilerSym    /.*\<SYMLINKD\>.*/
syn match LfilerExt1   /\(\<exe\>\|\<EXE\>\|\<o\>\|\<xml\>\|\<doc\>\|\<lzh\>\|\<7z\>\|\<jpg\>\|\<lzma\>\|\<vcproj\>\)/
syn match LfilerExt2   /\(\<dll\>\|\<DLL\>\|\<h\>\|\<php\>\|\<xls\>\|\<zip\>\|\<gz\>\|\<tif\>\|\<html\>\|\<class\>\)/
syn match LfilerExt3   /\(\<obj\>\|\<OBJ\>\|\<C\>\|\<XML\>\|\<pdf\>\|\<cab\>\|\<pl\>\|\<png\>\|\<xaml\>\|\<sln\>\)/
syn match LfilerExt4   /\(\<cpp\>\|\<CPP\>\|\<c\>\|\<ini\>\|\<psd\>\|\<tar\>\|\<ps\>\|\<bmp\>\|\<java\>\|\<txt\>\)/
syn match LfilerExt5   /\(\<lnk\>\|\<LNK\>\|\<O\>\|\<def\>\|\<dws\>\|\<bat\>\|\<cc\>\|\<ras\>\|\<HTML\>\)/
syn match LfilerExt6   /\(\<sys\>\|\<SYS\>\|\<H\>\|\<log\>\|\<DOC\>\|\<vim\>\|\<CC\>\|\<gif\>\|\<XML\>\)/
syn match LfilerPath   /[a-zA-Z]:\\.*\\/
syn match LfilerUnc    /\\\\.*\\/
syn match LfilerYTitle '<< yanked files >>'
syn match LfilerFTitle '<< find files >>'
syn match LfilerCTitle '<< command >>'
syn match LfilerBTitle '<< bookmark files >>'
syn match LfilerMTitle '<< mru files >>'
syn match LfilerHeader /^.* のディレクトリ.*$/
syn match LfilerInfo1  /^.*個のファイル.* バイト$/
syn match LfilerInfo2  /^.*個のディレクトリ.* バイトの空き領域$/
syn match LfilerSort   /\(\<name\>\|\<size\>\|\<time\>\|\<extension\>\)/

hi default LfilerInfo   guifg=#6666DD gui=none
hi default LfilerDir    guifg=#DDDD66 gui=none
hi default LfilerSym    guifg=#DDDDAA gui=none
hi default LfilerExt1   guifg=#FF0000 gui=none
hi default LfilerExt2   guifg=#00FF00 gui=none
hi default LfilerExt3   guifg=#0080FF gui=none
hi default LfilerExt4   guifg=#FFFF00 gui=none
hi default LfilerExt5   guifg=#008000 gui=none
hi default LfilerExt6   guifg=#00FFFF gui=none
hi default LfilerPath   guifg=#6688AA gui=none
hi default LfilerUnc    guifg=#6688AA gui=none
hi default LfilerYTitle guifg=#66FF99 gui=underline
hi default LfilerFTitle guifg=#66FF99 gui=underline
hi default LfilerCTitle guifg=#66FF99 gui=underline
hi default LfilerBTitle guifg=#66FF99 gui=underline
hi default LfilerMTitle guifg=#66FF99 gui=underline
hi default LfilerHeader guifg=#66FF99 gui=none
hi default LfilerInfo1  guifg=#666666 gui=none
hi default LfilerInfo2  guifg=#666666 gui=none
hi default LfilerSort   guifg=#80EEEE

let b:LFiler_syntax = 1
