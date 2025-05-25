"
" Edit this file to manage persistant abbreviations et al; source it to load them.
"

:autocmd FileType markdown iab -- —
:autocmd FileType markdown iab a: > [!ATTENTION]
:autocmd FileType markdown iab b: > [!BUG]
:autocmd FileType markdown iab e: > [!ERROR]
:autocmd FileType markdown iab faq: > [!FAQ]
:autocmd FileType markdown iab i: > [!IMPORTANT]
:autocmd FileType markdown iab n: > [!NOTE]
:autocmd FileType markdown iab tip: > [!TIP]
:autocmd FileType markdown iab tldr: > [!TLDR]
:autocmd FileType markdown iab w: > [!WARNING]

:iab <expr> dd strftime('%Y-%m-%d-%a')
:iab <expr> dt strftime('%Y-%m-%d-%a %H:%M')
:iab <expr> tt strftime('%H:%M')
:autocmd FileType markdown iab <expr> td: "- [ ] " .. strftime("%Y-%m-%d-%a") .. ":"  " Dated todo
:autocmd FileType markdown iab <expr> le: "### " .. strftime("%Y-%m-%d-%a")           " Log entry

:iab admin administrative
:iab app application
:iab apps applications
:iab bk Bitcoin Knots
:iab btc Bitcoin
:iab conf configuration
:iab confs configurations
:iab cz Chezmoi
:iab dir directory
:iab dirs directories
:iab eth Ethereum
:iab eu European Union
:iab h1 #
:iab h2 ##
:iab h3 ###
:iab h4 ####
:iab h5 #####
:iab h6 ######
:iab hm Home Manager
:iab lo LibreOffice
:iab loc LibreOffice Calc
:iab lod LibreOffice Draw
:iab low LibreOffice Writer
:iab md Markdown
:iab nv Neovim
:iab ob Obsidian
:iab potus the president of the United States of America
:iab repo repository
:iab tblsp tablespoon
:iab tbsp tablespoon
:iab tsp teaspoon
:iab uk United Kingdom
:iab usa United States of America
