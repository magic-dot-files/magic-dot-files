" .vimrc inspired by:
"        https://github.com/spf13/spf13-vim
"        https://github.com/zaiste/vimified

" General {
    " Use Vim settings, rather then Vi settings.
    " This must be first, because it changes other options as a side effect.
    set nocompatible


    let g:mdf_disable_arrow_keys = 0
    let g:mdf_space_instead_of_tab = 1
    let g:mdf_tabsize = 4
    let g:mdf_listchars = 1


    set vb t_vb=                " disable the fcking beep
    "set visualbell             " visual bell instead of beeping

    if has('vim_starting')
        set runtimepath+=~/.vim/bundle/neobundle.vim/
    endif

    call neobundle#rc(expand('~/.vim/bundle/'))

    " Bundles {

        " Let NeoBundle manage NeoBundle
        NeoBundleFetch 'Shougo/neobundle.vim'

        " General {
            " from github
            NeoBundle 'Shougo/vimproc', {
                  \ 'build' : {
                  \     'windows' : 'make -f make_mingw32.mak',
                  \     'cygwin' : 'make -f make_cygwin.mak',
                  \     'mac' : 'make -f make_mac.mak',
                  \     'unix' : 'make -f make_unix.mak',
                  \    },
                  \ }

            NeoBundle 'Shougo/vimshell.vim'
            NeoBundle 'kien/ctrlp.vim'
            NeoBundle 'ciaranm/detectindent'
            NeoBundle 'scrooloose/nerdtree'
            NeoBundle 'mbbill/undotree'
            NeoBundle 'jistr/vim-nerdtree-tabs'
            NeoBundle 'tpope/vim-fugitive'
            NeoBundle 'bling/vim-airline'
            NeoBundle 'tpope/vim-repeat'
            NeoBundle 'tpope/vim-surround'
            NeoBundle 'xolox/vim-session', {'depends' :
                \ [ 'xolox/vim-misc', ]}
            NeoBundle 'regedarek/ZoomWin'

            " from vim-scripts
            NeoBundle 'matchit.zip'
            NeoBundle 'RelOps'
            NeoBundle 'restore_view.vim'
        " }

        " Programming {
            " from github
            NeoBundle 'scrooloose/nerdcommenter'
            NeoBundle 'scrooloose/syntastic'
            NeoBundle 'godlygeek/tabular'
            NeoBundle 'majutsushi/tagbar'
            NeoBundle 'nathanaelkane/vim-indent-guides'
            NeoBundle 'terryma/vim-multiple-cursors'
            NeoBundle 'ciaranm/detectindent'
            NeoBundle 'Valloric/YouCompleteMe'
            NeoBundle 'airblade/vim-gitgutter.git'

            " from bitbucket
            NeoBundle 'bb:abudden/taghighlight'

            " from vim-scripts
            NeoBundle 'a.vim'
            NeoBundle 'DoxygenToolkit.vim'
        " }

        " FileType {
            " bindzone {
                NeoBundleLazy 'seveas/bind.vim', {
                    \   'autoload' : {
                    \       'filetypes' : ['zone'],
                    \       },
                    \   }
            " }

            " java {
                NeoBundleLazy 'javacomplete', {
                    \   'autoload' : {
                    \       'filetypes' : ['java'],
                    \       },
                    \   }
            " }

            " json {
                NeoBundleLazy 'elzr/vim-json', {
                    \   'autoload' : {
                    \       'filetypes' : ['json'],
                    \       },
                    \   }
            " }

            " javascript {
                NeoBundleLazy 'marijnh/tern_for_vim', {
                    \   'autoload' : {
                    \       'filetypes' : ['javascript', 'json'],
                    \       },
                    \   }
            " }

            " markdown {
                NeoBundleLazy 'tpope/vim-markdown', {
                    \   'autoload' : {
                    \       'filetypes' : ['markdown', 'md', 'mdown', 'mkd', 'mkdn'],
                    \       },
                    \   }
            " }
        " }

        " Installation check.
         NeoBundleCheck
    " }

    set shortmess+=filmnrxoOtT                              " abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash         " better unix / windows compatibility
    "set virtualedit=onemore                                " allow for cursor beyond last character
    set history=1000                                        " keep 1000 lines of command line history
    "set spell                                              " spell checking on
    set hidden                                              " allow buffer switching without saving
    set tabpagemax=15                                       " only show 15 tabs

    set backup                                              " keep a backup file

    " The current directory is the directory of the file in the current window.
    "if has("autocmd")
    "  autocmd BufEnter * :lchdir %:p:h
    "endif

    autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

    set browsedir=current           " which directory to use for the file browser

    set popt=left:8pc,right:3pc     " print options

    if version >= 730
        if has("autocmd")
            " Autosave & Load Views.
            autocmd BufWritePost,WinLeave,BufWinLeave ?* if MakeViewCheck() | mkview | endif
            autocmd BufWinEnter ?* if MakeViewCheck() | silent! loadview | endif
        endif
    else
        " When editing a file, always jump to the last known cursor position.
        " Don't do it when the position is invalid or when inside an event handler
        " (happens when dropping a file on gvim).
        if has("autocmd")
          autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \   exe "normal! g`\"" |
                \ endif
        endif " has("autocmd")
    endif

    " When vimrc is edited, reload it
    autocmd! BufWritePost vimrc source ~/.vimrc

    " Stupid shift key fixes
    if has("user_commands")
        command! -bang -nargs=* -complete=file E e<bang> <args>
        command! -bang -nargs=* -complete=file W w<bang> <args>
        command! -bang -nargs=* -complete=file Wq wq<bang> <args>
        command! -bang -nargs=* -complete=file WQ wq<bang> <args>
        command! -bang Wa wa<bang>
        command! -bang WA wa<bang>
        command! -bang Q q<bang>
        command! -bang QA qa<bang>
        command! -bang Qa qa<bang>
        command! -bang Qal qa<bang>
        command! -bang Qall qa<bang>
        command! -bang QALL qa<bang>
    endif
    cmap Tabe tabe

    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null

    " visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    if g:mdf_disable_arrow_keys
        " You want to be part of the gurus? Time to get in serious stuff and stop using
        " arrow keys.
        noremap <left> <nop>
        noremap <up> <nop>
        noremap <down> <nop>
        noremap <right> <nop>
    endif
" }

" Appearance {
    set background=dark

    highlight Pmenu ctermfg=black ctermbg=lightgray
    highlight PmenuSel ctermfg=white ctermbg=darkgray
    highlight PmenuSbar ctermfg=lightcyan ctermbg=lightcyan
    highlight PmenuThumb ctermfg=lightgray ctermbg=darkgray

    " Change the behavior of the <Enter> key when the popup menu is visible.
    " The Enter key will simply select the highlighted menu item, just as <C-Y> does.
    inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

    if has("gui_running")
        colorscheme evening
    endif

    set nolazyredraw                    " Don't redraw while executing macros

    set showmode                        " Show editing mode
    set showmatch                       " Show matching bracets when text indicator is over them

    if has('cmdline_info')
        set ruler                       " show the cursor position all the time
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids"
        set showcmd                     " display partial commands
    endif

    set cursorline                      " Highlighting that moves with the cursor
    highlight CursorLine term=bold cterm=bold guibg=Grey40

    highlight clear SignColumn          " SignColumn should match background for
                                        " things like vim-gitgutter

    highlight clear LineNr              " Current line number row will have same background color in relative mode.
                                        " Things like vim-gitgutter will match LineNr highlight

    set splitright

    "set mouse=a                        " enable the use of the mouse
    "set nowrap                         " do not wrap lines

    set wildmenu                                        " command-line completion in an enhanced mode
    set wildmode=list:longest,full                      " command <Tab> completion, list matches, then longest common part, then all.
    set wildignore=*.bak,*.o,*.e,*~,*.obj,.git,*.pyc    " wildmenu: ignore these extensions

    set whichwrap=b,s,h,l,<,>,[,]                       " backspace and cursor keys wrap to

    if g:mdf_listchars
        set list
        set listchars=tab:»·,trail:·,extends:#,nbsp:.       " strings to use in 'list' mode
    endif

    "set scrolljump=5                                   " lines to scroll when cursor leaves screen
    set scrolloff=5                                     " always have some lines of text when scrolling

    " Folding {
        " Enable folding, but by default make it act like folding is off, because
        " folding is annoying in anything but a few rare cases
        set foldenable                          " Turn on folding
        set foldmethod=indent                   " Make folding indent sensitive
        set foldlevel=100                       " Don't autofold anything (but I can still fold manually)
        set foldopen-=search                    " don't open folds when you search into them
        set foldopen-=undo                      " don't open folds when you undo stuff
    " }

    if has('statusline')
        set laststatus=2
    endif

    " from http://vim.wikia.com/wiki/Highlight_unwanted_spaces
    if has("autocmd")
        highlight ExtraWhitespace ctermbg=red guibg=red
        match ExtraWhitespace /\s\+$/
        autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
        autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
        autocmd InsertLeave * match ExtraWhitespace /\s\+$/
        autocmd BufWinLeave * call clearmatches()
    endif

    " GUI Settings {
        " GVIM- (here instead of .gvimrc)
        if has('gui_running')
            set guioptions-=T " remove the toolbar
            set lines=40 " 40 lines of text instead of 24,
            if has('gui_macvim')
                set transparency=5 " Make the window slightly transparent
            endif
        else
            " Set term to xterm to make <Home> and <End> keys work properly
            if match($TERM, "screen*") != -1 || match($TERM, "xterm*") != -1
                set term=xterm-256color
                set t_Co=256 " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
            endif
        endif
    " }
" }

" Editing {
    " Enable file type detection. Use the default filetype settings.
    " Also load indent files, to automatically do language-dependent indenting.
    filetype plugin indent on

    " Switch syntax highlighting on, when the terminal has colors
    " Also switch on highlighting the last used search pattern.
    if &t_Co > 2 || has("gui_running")
        syntax on
    endif

    set backspace=indent,eol,start                  " backspacing over everything in insert mode

    set autoread                                    " auto reread file when changed outside Vim
    set autowrite                                   " write a modified buffer on each :next , ...

    "set complete+=k                                " scan the files given with the 'dictionary' option
    "set dictionary+=/usr/share/dict/words          " dictionary for word auto completion

    " Formatting {
        autocmd FileType Makefile set g:mdf_space_instead_of_tab = 0
        if g:mdf_space_instead_of_tab
            set expandtab                    " tabs are spaces, not tabs"
        endif

        if !g:mdf_tabsize
            let g:mdf_tabsize = 4
        endif

        " number of spaces to use for each step of indent
        execute "set shiftwidth=".g:mdf_tabsize
        " number of spaces that a <Tab> counts for
        execute "set tabstop=".g:mdf_tabsize
        " let backspace delete indent
        execute "set softtabstop=".g:mdf_tabsize

        set autoindent                  " copy indent from current line
        set smartindent                 " smart autoindenting when starting a new line
    " }

    " Clipboard {
        set clipboard=unnamed
        "let @*=@a
    " }

    " Undo {
        if has('persistent_undo')
            set undofile                "so is persistent undo ...
            set undolevels=1000         "maximum number of changes that can be undone
            set undoreload=10000        "maximum number lines to save for undo on a buffer reload
        endif
    " }

    " Encoding {
        scriptencoding utf-8
        set encoding=utf-8              " Use UTF-8.
    " }

    " Searching {
        set hlsearch                    " highlight the last used search pattern
        set incsearch                   " do incremental searching
        "set ignorecase                 " Ignore case when searching.
        set smartcase                   " case-sensitive if search contains an uppercase character

        " clearing highlighted search
        noremap <leader><space> :noh<cr>:call clearmatches()<cr>
    " }
" }

" Filetype actions {
    if has("autocmd")
        autocmd BufNewFile,BufRead *.pro,*.pri  set filetype=qmake
        autocmd BufNewFile,BufRead *.qml,*.qmlproject set filetype=qml
    endif
" }

" Abreviations {
    ab belemrev Reviewed-by: Rodrigo Belem <rodrigo.belem@gmail.com>
    ab belemsig Signed-off-by: Rodrigo Belem <rodrigo.belem@gmail.com>
" }

" Plugins {

    " PIV {
        let g:DisableAutoPHPFolding = 0
        let g:PIVAutoClose = 0
    " }

    " Misc {
        let g:NERDShutUp=1
        let b:match_ignorecase = 1
    " }

    " OmniComplete {
        if has("autocmd") && exists("+omnifunc")
            autocmd Filetype *
                \if &omnifunc == "" |
                \setlocal omnifunc=syntaxcomplete#Complete |
                \endif
        endif

        "hi Pmenu guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=Lightgray
        "hi PmenuSbar guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
        "hi PmenuThumb guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE

        " automatically open and close the popup menu / preview window
        au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
        set completeopt=menu,preview,longest
    " }

    " Ctags {
        set tags=./tags;/,~/.vimtags

        " Make tags placed in .git/tags file available in all levels of a repository
        let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
        if gitroot != ''
            let &tags = &tags . ',' . gitroot . '/.git/tags'
        endif
    " }

    " AutoCloseTag {
    " Make it so AutoCloseTag works for xml and xhtml files as well
        au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
        nmap <Leader>ac <Plug>ToggleAutoCloseMappings
    " }

    " SnipMate {
        " Setting the author var
        " If forking, please overwrite in your .vimrc.local file
        let g:snips_author = 'Rodrigo Belem <rodrigo.belem@gmail.com>'
    " }

    " NerdTree {
        map <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
        map <leader>e :NERDTreeFind<CR>
        nmap <leader>nt :NERDTreeFind<CR>

        let NERDTreeShowBookmarks=1
        let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr', '\.bak', '\.o', '\.e', '\.obj']
        let NERDTreeChDirMode=0
        let NERDTreeQuitOnOpen=1
        let NERDTreeShowHidden=1
        let NERDTreeKeepTreeInNewTab=1
    " }

    " NERDTreeTabs {
        map <Leader>n <plug>NERDTreeTabsToggle<CR>

        " open a NERDTree automatically when vim starts up if no files were specified
        autocmd vimenter * if !argc() | NERDTree | endif
    " }

    " Tabularize {
        if exists(":Tabularize")
            nmap <Leader>a= :Tabularize /=<CR>
            vmap <Leader>a= :Tabularize /=<CR>
            nmap <Leader>a: :Tabularize /:<CR>
            vmap <Leader>a: :Tabularize /:<CR>
            nmap <Leader>a:: :Tabularize /:\zs<CR>
            vmap <Leader>a:: :Tabularize /:\zs<CR>
            nmap <Leader>a, :Tabularize /,<CR>
            vmap <Leader>a, :Tabularize /,<CR>
            nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
            vmap <Leader>a<Bar> :Tabularize /<Bar><CR>

            " The following function automatically aligns when typing a
            " supported character
            inoremap <silent> <Bar> <Bar><Esc>:call <SID>align()<CR>a

            function! s:align()
                let p = '^\s*|\s.*\s|\s*$'
                if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
                    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
                    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
                    Tabularize/|/l1
                    normal! 0
                    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
                endif
            endfunction

        endif
    " }

    " Session List {
        set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
        nmap <leader>sl :SessionList<CR>
        nmap <leader>ss :SessionSave<CR>
    " }

    " Buffer explorer {
        nmap <leader>b :BufExplorer<CR>
    " }

    " JSON {
        nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
    " }

    " PyMode {
        let g:pymode_lint_checker = "pyflakes"
        let g:pymode_utils_whitespaces = 0
    " }

    " ctrlp {
        nnoremap <silent> <D-t> :CtrlP<CR>
        nnoremap <silent> <D-r> :CtrlPMRU<CR>
        let g:ctrlp_working_path_mode = 'ra'
        let g:ctrlp_root_markers = ['configure.ac', 'configure.in', '.repo', '.pro']
        let g:ctrlp_custom_ignore = {
            \ 'dir': '\.git$\|\.hg$\|\.svn$',
            \ 'file': '\.exe$\|\.so$\|\.dll$' }
        let g:ctrlp_user_command = {
                \ 'types': {
                        \ 1: ['.git', 'cd %s && git ls-files'],
                        \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                        \ },
                \ 'fallback': 'find %s -type f'
                \ }
    "}

    " TagBar {
        nnoremap <silent> <leader>tt :TagbarToggle<CR>
    "}

    " PythonMode {
        " Disable if python support not present
        if !has('python')
            let g:pymode = 1
        endif
    " }

    " Fugitive {
        nnoremap <silent> <leader>gs :Gstatus<CR>
        nnoremap <silent> <leader>gd :Gdiff<CR>
        nnoremap <silent> <leader>gc :Gcommit<CR>
        nnoremap <silent> <leader>gb :Gblame<CR>
        nnoremap <silent> <leader>gl :Glog<CR>
        nnoremap <silent> <leader>gp :Git push<CR>
    "}

    " YouCompleteMe {
        nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>

        let g:ycm_collect_identifiers_from_tags_files = 1
        let g:ycm_seed_identifiers_with_syntax = 1
    " }

    " javacomplete {
        if glob('AndroidManifest.xml') =~ ''
            if filereadable('project.properties')
                let s:androidSdkPath = '/opt/android-sdk-linux'
                " the following line uses external tools and is less portable
                "let s:androidTargetPlatform = system('grep target= project.properties | cut -d \= -f 2')
                vimgrep /target=/j project.properties
                let s:androidTargetPlatform = split(getqflist()[0].text, '=')[1]
                let s:targetAndroidJar = s:androidSdkPath . '/platforms/' . s:androidTargetPlatform . '/android.jar'

                call javacomplete#SetClassPath(s:targetAndroidJar . ':libs/android-support-v4.jar:bin/classes')
            end
        endif
    " }

    " UndoTree {
        nnoremap <c-u> :UndotreeToggle<CR>
    " }

    " vim-airline {
        let g:airline_powerline_fonts = 1

        let g:airline_theme = 'powerlineish'
        if !exists('g:airline_powerline_fonts')
            " Use the default set of separators with a few customizations
            let g:airline_left_sep='›' " Slightly fancier than '>'
            let g:airline_right_sep='‹' " Slightly fancier than '<'
        endif
    " }
" }

" Functions {
    function! NERDTreeInitAsNeeded()
        redir => bufoutput
        buffers!
        redir END
        let idx = stridx(bufoutput, "NERD_tree")
        if idx > -1
            NERDTreeMirror
            NERDTreeFind
            wincmd l
        endif
    endfunction

    " automatically remove trailing whitespace before write
    function! StripTrailingWhitespace()
        normal mZ
        %s/\s\+$//e
        if line("'Z") != line(".")
            echo "Stripped whitespace\n"
        endif
        normal `Z
    endfunction
    "autocmd BufWritePre * :call StripTrailingWhitespace()
    "autocmd BufEnter * :call StripTrailingWhitespace()

    function! MakeViewCheck()
        if has('quickfix') && &buftype =~ 'nofile' | return 0 | endif
        if expand('%') =~ '\[.*\]' | return 0 | endif
        if empty(glob(expand('%:p'))) | return 0 | endif
        if &modifiable == 0 | return 0 | endif
        if len($TEMP) && expand('%:p:h') == $TEMP | return 0 | endif
        if len($TMP) && expand('%:p:h') == $TMP | return 0 | endif

        let file_name = expand('%:p')
        for ifiles in g:skipview_files
            if file_name =~ ifiles
                return 0
            endif
        endfor

        return 1
    endfunction

    function! InitializeDirectories()
        let separator = "."
        let parent = $HOME
        let prefix = '.vim'
        let dir_list = {
                    \ 'backup': 'backupdir',
                    \ 'views': 'viewdir',
                    \ 'swap': 'directory' }

        if has('persistent_undo')
            let dir_list['undo'] = 'undodir'
        endif

        for [dirname, settingname] in items(dir_list)
            let directory = parent . '/' . prefix . dirname . "/"
            if exists("*mkdir")
                if !isdirectory(directory)
                    call mkdir(directory)
                endif
            endif
            if !isdirectory(directory)
                echo "Warning: Unable to create backup directory: " . directory
                echo "Try: mkdir -p " . directory
            else
                let directory = substitute(directory, " ", "\\\\ ", "g")
                exec "set " . settingname . "=" . directory
            endif
        endfor
    endfunction
    call InitializeDirectories()
" }
