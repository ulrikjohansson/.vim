set nocompatible
filetype off

" Download Vundle if not available
if !isdirectory(expand("~/.vim/bundle/Vundle.vim/.git"))
	    !git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
endif

set rtp +=~/.vim/bundle/Vundle.vim

call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive', {'pinned': 1}

call vundle#end()

filetype plugin indent on
syntax on
