return {
  'srackham/digraph-picker.nvim',
  enabled = false,
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    local picker = require('digraph-picker')
    picker.setup({
      digraphs = {
        { digraph = 'sm', symbol = '☺', name = 'Smiling face' },
        { digraph = 'fr', symbol = '☹', name = 'Frowning face' },
        { digraph = 'ht', symbol = '♥', name = 'Heart' },
        { digraph = 'ck', symbol = '✓', name = 'Check mark (tick)' },
        { digraph = 'xx', symbol = '✗', name = 'Cross mark' },
        { digraph = 'su', symbol = '☀', name = 'Sun' },
        { digraph = 'mn', symbol = '☽', name = 'Moon' },
        { digraph = 'cl', symbol = '☁', name = 'Cloud' },
        { digraph = 'um', symbol = '☂', name = 'Umbrella' },
        { digraph = 'fl', symbol = '⚑', name = 'Flag' },
        { digraph = 'wr', symbol = '✎', name = 'Pencil' },
        { digraph = 'sc', symbol = '✂', name = 'Scissors' },
        { digraph = 'tm', symbol = '™', name = 'Trademark' },
        { digraph = 'co', symbol = '©', name = 'Copyright' },
        { digraph = 'rg', symbol = '®', name = 'Registered' },
        { digraph = 'dg', symbol = '°', name = 'Degree' },
        { digraph = 'pi', symbol = 'π', name = 'Pi' },
        { digraph = 'in', symbol = '∞', name = 'Infinity' },
        { digraph = 'dg', symbol = '†', name = 'Dagger' },
        { digraph = 'el', symbol = '…', name = 'Ellipsis' },
        { digraph = 'em', symbol = '—', name = 'Em dash' },
        { digraph = 'ne', symbol = '≠', name = 'Not equal' },
        { digraph = 've', symbol = '⋮', name = 'Vertical ellipsis' },
        { digraph = 'lq', symbol = '“', name = 'Left double quote' },
        { digraph = 'rq', symbol = '”', name = 'Right double quote' },
        { digraph = 'ae', symbol = '≈', name = 'Approximately equal' },
        { digraph = 'le', symbol = '≤', name = 'Less than or equal' },
        { digraph = 'ge', symbol = '≥', name = 'Greater than or equal' },
        { digraph = 'pp', symbol = '¶', name = 'Pilcrow (paragraph sign)' },
        -- Nerd Font characters (Nerd Fonts must be installed)
        { digraph = 'rk', symbol = '', name = 'Rocket' },
        { digraph = 'im', symbol = '', name = 'Image' },
        { digraph = 'do', symbol = '󰈙', name = 'Document' },
        { digraph = 'gr', symbol = '', name = 'Gears' },
      },
    })
    vim.keymap.set({ 'i', 'n' }, '<C-k><C-k>', picker.insert_digraph,
      { noremap = true, silent = true, desc = "Digraph picker" })
  end,
}
