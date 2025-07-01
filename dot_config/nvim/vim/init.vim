"
" Edit this file to manage persistant abbreviations et al; source it to load them.
"

:autocmd FileType markdown iab <expr> Td "- [ ] _" .. strftime("%d-%b-%Y") .. "_:"  " Dated todo
:autocmd FileType markdown iab <expr> Le "### " .. strftime("%d-%b-%Y")             " Log entry

:iab <expr> Dd strftime('%Y-%m-%d')         " Date
:iab <expr> Tm strftime('%H:%M')            " Time
:iab <expr> Dt strftime('%Y-%m-%d %H:%M')   " Date and time

:iab Aip AI prompt
:iab Air AI response
:iab App application
:iab Apps applications
:iab Bk Bitcoin Knots
:iab Btc Bitcoin
:iab Cl command line
:iab Conf configuration
:iab Confs configurations
:iab Cwd current working directory
:iab Cz Chezmoi
:iab Dir directory
:iab Dirs directories
:iab Esp especially
:iab Eth Ethereum
:iab Eu European Union
:iab Gh Github
:iab Gfm Github Flavored Markdown
:iab H1 #
:iab H2 ##
:iab H3 ###
:iab H4 ####
:iab H5 #####
:iab H6 ######
:iab Id identifier
:iab Ids identifiers
:iab Jj Jujutsu
:iab Lh left hand
:iab Lhs left hand side
:iab Hm Home Manager
:iab Lo LibreOffice
:iab Lg Lazygit
:iab Lv LazyVim
:iab Mk Markdown
:iab Nv Neovim
:iab No NixOS
:iab Ob Obsidian
:iab Onv `obsidian.nvim`
:iab Omv OpenMediaVault
:iab Pkm Personal Knowledge Management (PKM)
:iab Pr pull request
:iab Ot Old Testament
:iab Nt New Testament
:iab Potus the president of the United States of America
:iab Repo repository
:iab Repos repositories
:iab Rh right hand
:iab Rhs right hand side
:iab Tbsp tablespoon
:iab Tsp teaspoon
:iab Uk United Kingdom
:iab Usa United States of America
:iab Vcs version control system
:iab Vcss version control systems
:iab Vsc VSCode
:iab Wrt with respect to 
:iab Xp Christian
