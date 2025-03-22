return {
  'srackham/digraph-picker.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    local picker = require('digraph-picker')
    picker.setup({
      digraphs = {
        { digraph = 'SM', symbol = '☺', name = 'SMILING FACE' },
        { digraph = 'FR', symbol = '☹', name = 'FROWNING FACE' },
        { digraph = 'HT', symbol = '♥', name = 'HEART' },
        { digraph = 'CK', symbol = '✓', name = 'CHECK MARK (TICK)' },
        { digraph = 'XX', symbol = '✗', name = 'CROSS MARK' },
        { digraph = 'SU', symbol = '☀', name = 'SUN' },
        { digraph = 'MN', symbol = '☽', name = 'MOON' },
        { digraph = 'CL', symbol = '☁', name = 'CLOUD' },
        { digraph = 'UM', symbol = '☂', name = 'UMBRELLA' },
        { digraph = 'FL', symbol = '⚑', name = 'FLAG' },
        { digraph = 'WR', symbol = '✎', name = 'PENCIL' },
        { digraph = 'SC', symbol = '✂', name = 'SCISSORS' },
        { digraph = 'TM', symbol = '™', name = 'TRADEMARK' },
        { digraph = 'CO', symbol = '©', name = 'COPYRIGHT' },
        { digraph = 'RG', symbol = '®', name = 'REGISTERED' },
        { digraph = 'DG', symbol = '°', name = 'DEGREE' },
        { digraph = 'PI', symbol = 'π', name = 'PI' },
        { digraph = 'IN', symbol = '∞', name = 'INFINITY' },
        { digraph = 'DG', symbol = '†', name = 'DAGGER' },
        { digraph = 'EL', symbol = '…', name = 'ELLIPSIS' },
        { digraph = 'EM', symbol = '—', name = 'EM DASH' },
        { digraph = 'NE', symbol = '≠', name = 'NOT EQUAL' },
        { digraph = 'VE', symbol = '⋮', name = 'VERTICAL ELLIPSIS' },
        { digraph = 'LQ', symbol = '“', name = 'LEFT DOUBLE QUOTE' },
        { digraph = 'RQ', symbol = '”', name = 'RIGHT DOUBLE QUOTE' },
        { digraph = 'AE', symbol = '≈', name = 'APPROXIMATELY EQUAL' },
        { digraph = 'LE', symbol = '≤', name = 'LESS THAN OR EQUAL' },
        { digraph = 'GE', symbol = '≥', name = 'GREATER THAN OR EQUAL' },
        { digraph = 'PP', symbol = '¶', name = 'PILCROW (PARAGRAPH SIGN)' },
        -- Nerd Font characters (Nerd Fonts must be installed)
        { digraph = 'RK', symbol = '', name = 'ROCKET' },
        { digraph = 'IM', symbol = '', name = 'IMAGE' },
        { digraph = 'DO', symbol = '󰈙', name = 'DOCUMENT' },
      },
    })
    vim.keymap.set('i', '<C-k><C-k>', picker.insert_digraph,
      { noremap = true, silent = true, desc = "Digraph picker" })
  end,
}
