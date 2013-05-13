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


    runtime unbundle/vim-unbundle/unbundle.vim
    call Unbundle('unbundle/general/*')
    call Unbundle('unbundle/programming/*')

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

    highlight Pmenu guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=Lightgray
    highlight PmenuSbar guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
    highlight PmenuThumb guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE

    if has("gui_running")
        colorscheme evening
    endif

    set nolazyredraw                    " Don't redraw while executing macros

    set showmode                        " Show editing mode
    set showmatch                       " Show matching bracets when text indicator is over them

    " enable powerline patched fonts
    let g:Powerline_symbols = 'fancy'

    if has('cmdline_info')
        set ruler                       " show the cursor position all the time
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids"
        set showcmd                     " display partial commands
    endif

    set cursorline                      " Highlighting that moves with the cursor

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
        "set statusline=[%{&ff}]\ [%Y]\ [pos:%04l,%04v][%p%%]\ [len:%L]\ %<%F%m%r%h%w

        " Broken down into easily includeable segments
        set statusline=%<%f\                        " Filename
        set statusline+=%w%h%m%r                    " Options
        set statusline+=%{fugitive#statusline()}    " Git Hotness
        set statusline+=\ [%{&ff}/%Y]               " filetype
        set statusline+=\ [%{getcwd()}]             " current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%     " Right aligned file nav info

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

    " neocomplcache {
        " Disable AutoComplPop.
        let g:acp_enableAtStartup = 0
        " Use neocomplcache.
        let g:neocomplcache_enable_at_startup = 1
        " Use smartcase.
        let g:neocomplcache_enable_smart_case = 1
        " Use camel case completion.
        let g:neocomplcache_enable_camel_case_completion = 1
        " Use underbar completion.
        let g:neocomplcache_enable_underbar_completion = 1
        " Set minimum syntax keyword length.
        let g:neocomplcache_min_syntax_length = 3
        let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

        " Define dictionary.
        let g:neocomplcache_dictionary_filetype_lists = {
            \ 'default' : '',
            \ 'vimshell' : $HOME.'/.vimshell_hist',
            \ 'scheme' : $HOME.'/.gosh_completions'
            \ }

        " Define keyword.
        if !exists('g:neocomplcache_keyword_patterns')
          let g:neocomplcache_keyword_patterns = {}
        endif
        let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

        " Plugin key-mappings.
        imap <C-k> <Plug>(neocomplcache_snippets_expand)
        smap <C-k> <Plug>(neocomplcache_snippets_expand)
        inoremap <expr><C-g> neocomplcache#undo_completion()
        inoremap <expr><C-l> neocomplcache#complete_common_string()

        " SuperTab like snippets behavior.
        "imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

        " Recommended key-mappings.
        " <CR>: close popup and save indent.
        "inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
        " <TAB>: completion.
        inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
        " <C-h>, <BS>: close popup and delete backword char.
        inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
        inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
        inoremap <expr><C-y>  neocomplcache#close_popup()
        inoremap <expr><C-e>  neocomplcache#cancel_popup()

        " Change the behavior of the <Enter> key when the popup menu is visible.
        " The Enter key will simply select the highlighted menu item, just as <C-Y> does.
        inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

        " AutoComplPop like behavior.
        let g:neocomplcache_enable_auto_select = 0

        " Shell like behavior(not recommended).
        "set completeopt+=longest
        "let g:neocomplcache_enable_auto_select = 1
        "let g:neocomplcache_disable_auto_complete = 1
        "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<TAB>"
        "inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"

        " Enable omni completion.
        autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
        autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
        autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
        autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
        autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
        autocmd FileType java setlocal omnifunc=javacomplete#Complete

        " Enable heavy omni completion.
        if !exists('g:neocomplcache_omni_patterns')
            let g:neocomplcache_omni_patterns = {}
        endif
        let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
        "autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
        let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
        let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
        let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'

        " For snippet_complete marker.
        if has('conceal')
            set conceallevel=2 concealcursor=i
        endif

        "let g:neocomplcache_enable_auto_delimiter = 1

        if !exists('g:neocomplcache_force_omni_patterns')
          let g:neocomplcache_force_omni_patterns = {}
        endif
        let g:neocomplcache_force_overwrite_completefunc = 1
        let g:neocomplcache_force_omni_patterns.c =
              \ '[^.[:digit:] *\t]\%(\.\|->\)'
        let g:neocomplcache_force_omni_patterns.cpp =
              \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
        let g:clang_complete_auto = 0
        let g:clang_auto_select = 0
        let g:clang_use_library   = 0
    " }

    " clang_complete {
        let g:clang_snippets = 1
        let g:clang_snippets_engine = 'clang_complete'
    " }

    " UndoTree {
        nnoremap <c-u> :UndotreeToggle<CR>
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
