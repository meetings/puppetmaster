" ~/.vimrc, 2015-01-08 / Tuomas Starck

syntax on
filetype plugin on

set guioptions=aci
set sw=2 ts=2 sts=2
set showcmd showmatch
set nojoinspaces
set expandtab
set incsearch
set smartcase
set hidden
set ruler

function! SudoSaveFile()
  :set buftype=nofile
  :w !sudo sponge %
endfunction

noremap <C-d>S :%s/\s\+$<CR>
cnoremap W! call SudoSaveFile()

if has("autocmd")
  au BufRead,BufNewFile *.txt set wrap linebreak textwidth=0
  au BufRead,BufNewFile *.py set autoindent
  au BufRead,BufNewFile *.{hs,clj} set sw=2 ts=2 sts=2 autoindent
  au BufRead,BufNewFile redirect.rules set syntax=perl
  au BufRead,BufNewFile {.bash,bash}* set syntax=sh
  au BufRead,BufNewFile .vimrc set sw=2 ts=2 sts=2
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif
