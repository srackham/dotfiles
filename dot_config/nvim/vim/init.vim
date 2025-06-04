"
" Edit this file to manage persistant abbreviations et al; source it to load them.
"

:autocmd FileType markdown iab -- —
:autocmd FileType markdown iab <expr> td: "- [ ] _" .. strftime("%Y-%m-%d-%a") .. "_:"  " Dated todo
:autocmd FileType markdown iab <expr> le: "### " .. strftime("%Y-%m-%d-%a")           " Log entry

:iab <expr> dt strftime('%Y-%m-%d')         " Date
:iab <expr> dd strftime('%Y-%m-%d-%a')      " Date with day
:iab <expr> tm strftime('%H:%M')            " Time
:iab <expr> dt strftime('%Y-%m-%d %H:%M')   " Date and time

:iab ap AI prompt
:iab ar AI response
:iab app application
:iab apps applications
:iab bk Bitcoin Knots
:iab btc Bitcoin
:iab config configuration
:iab configs configurations
:iab cz Chezmoi
:iab dir directory
:iab dirs directories
:iab esp especially
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
:iab mk Markdown
:iab nv Neovim
:iab ob Obsidian
:iab omv OpenMediaVault
:iab pkm Personal Knowledge Management (PKM)
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
:iab wrt with respect to 
