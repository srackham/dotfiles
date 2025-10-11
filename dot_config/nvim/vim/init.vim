"
" Edit this file to manage persistant abbreviations et al; source it to load them.
"

:autocmd FileType markdown iab <expr> Td "- [ ] _" .. strftime("%d-%b-%Y") .. "_:"  " Dated todo
:autocmd FileType markdown iab <expr> Le "### " .. strftime("%d-%b-%Y")             " Log entry

:iab <expr> DD strftime('%d-%b-%Y')             " Date
:iab <expr> TT strftime('%H:%M')                " Time
:iab <expr> DT strftime('%Y-%m-%d %H:%M')       " Date and time
:iab <expr> DS strftime('%Y-%m-%d')             " ISO 8601 date stamp
:iab <expr> DTS strftime('%Y-%m-%dT%H:%M:%S%z') " ISO 8601 date and time stamp

:iab Mon Monday
:iab Tue Tuesday
:iab Wed Wednesday
:iab Thu Thursday
:iab Fri Friday
:iab Sat Saturday
:iab Sun Sunday

:iab Aip AI prompt
:iab Air AI response
:iab App application
:iab Apps applications
:iab Bk Bitcoin Knots
:iab Btc Bitcoin
:iab Cl command line
:iab Conf configuration
:iab Confs configurations
:iab Ctk Christ the King
:iab Cwd current working directory
:iab Cz chezmoi
:iab Dir directory
:iab Dirs directories
:iab Docs documentation
:iab EL Ecclesiastical Latin
:iab Ev environment variable
:iab CL Classical Latin
:iab Esp especially
:iab Eth Ethereum
:iab Eu European Union
:iab Gh Github
:iab Gfm Github Flavored Markdown
:iab Gp general purpose
:iab H1 #
:iab H2 ##
:iab H3 ###
:iab H4 ####
:iab H5 #####
:iab H6 ######
:iab Id identifier
:iab Ids identifiers
:iab Imo In my opinion
:iab Jj Jujutsu
:iab Kjv King James Version
:iab Lh left hand
:iab Lhs left hand side
:iab Hm Home Manager
:iab Lo LibreOffice
:iab Lg Lazygit
:iab Lv LazyVim
:iab Mk Markdown
:iab Nv Neovim
:iab NO Novus Ordo
:iab VO Vetus Ordo
:iab TLM Tridentine Latin Mass
:iab Ob Obsidian
:iab Onv `obsidian.nvim`
:iab Omv OpenMediaVault
:iab Otoh on the other hand
:iab Pkm Personal Knowledge Management (PKM)
:iab Pr pull request
:iab Re regular expression
:iab Res regular expressions
:iab Ot Old Testament
:iab Nt New Testament
:iab Potus the president of the United States of America
:iab Repo repository
:iab Repos repositories
:iab Rh right hand
:iab Rhs right hand side
:iab St Saint
:iab STM Saint Thomas More Church
:iab Tbsp tablespoon
:iab Tsp teaspoon
:iab Ui user interface
:iab Uk United Kingdom
:iab Usa United States of America
:iab Vb VirtualBox
:iab Vcs version control system
:iab Vcss version control systems
:iab Vsc VSCode
:iab Wrt with respect to
:iab Xp Christian
:iab Xps Christians
:iab Xpy Christianity
