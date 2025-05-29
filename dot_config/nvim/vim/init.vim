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

:iab <expr> d strftime('%Y-%m-%d')          " Date
:iab <expr> dd strftime('%Y-%m-%d-%a')      " Date with day
:iab <expr> t strftime('%H:%M')             " Time
:iab <expr> dt strftime('%Y-%m-%d %H:%M')   " Date and time
:autocmd FileType markdown iab <expr> td: "- [ ] " .. strftime("%Y-%m-%d-%a") .. ":"  " Dated todo
:autocmd FileType markdown iab <expr> le: "### " .. strftime("%Y-%m-%d-%a")           " Log entry

:iab ap AI prompt
:iab ar AI response
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
:iab lh left hand
:iab lhs left hand side
:iab hm Home Manager
:iab lo LibreOffice
:iab loc LibreOffice Calc
:iab lod LibreOffice Draw
:iab low LibreOffice Writer
:iab md Markdown
:iab nv Neovim
:iab ob Obsidian
:iab ot Old Testament
:iab nt New Testament
:iab potus the president of the United States of America
:iab repo repository
:iab rh right hand
:iab rhs right hand side
:iab tblsp tablespoon
:iab tbsp tablespoon
:iab tsp teaspoon
:iab uk United Kingdom
:iab usa United States of America
:iab vsc VSCode
