
set runtimepath^=~/.vim runtimepath+=~/.vim/after runtimepath+=~/.config/nvim/test
let &packpath = &runtimepath

source ~/.vimrc

tnoremap <tab><tab> <c-\><c-n>
