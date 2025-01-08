return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'leoluz/nvim-dap-go',
  },
  config = function()
    local dap, dapui, dapgo = require("dap"), require("dapui"), require('dap-go')

    dapui.setup()
    dapgo.setup()

    dap.listeners.before.attach.dapui_config = dapui.open
    dap.listeners.before.launch.dapui_config = dapui.open
    dap.listeners.before.event_terminated.dapui_config = dapui.close
    dap.listeners.before.event_exited.dapui_config = dapui.close

    vim.keymap.set('n', '<Leader>dc', dap.continue, { desc = "Debug continue" })
    vim.keymap.set('n', '<Leader>dC', dap.clear_breakpoints, { desc = "Clear all breakpoints" })
    vim.keymap.set('n', '<Leader>dd', dap.step_over, { desc = "Debug step over" })
    vim.keymap.set('n', '<Leader>di', dap.step_into, { desc = "Debug step into" })
    vim.keymap.set('n', '<Leader>dj', dap.focus_frame, { desc = "Jump to debug cursor" })
    vim.keymap.set('n', '<Leader>do', dap.step_out, { desc = "Debug step out" })
    vim.keymap.set('n', '<Leader>dr', dap.run_to_cursor, { desc = "Run to cursor" })
    vim.keymap.set('n', '<Leader>dR', dap.restart, { desc = "Restart the debug session" })
    vim.keymap.set('n', '<Leader>db', dap.toggle_breakpoint, { desc = "Debug toggle breakpoint" })
    vim.keymap.set('n', '<Leader>du', dapui.toggle, { desc = "Debug toggle UI" })
    vim.keymap.set('n', '<Leader>dU', function() dapui.open({ reset = true }) end,
      { desc = "Open and reinitialize the debug UI" })
    vim.keymap.set('n', '<Leader>dx', dap.terminate, { desc = "Debug terminate" })

    vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DapBreakpoint' })
    vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = 'red' })
    vim.fn.sign_define('DapStopped', { text = '▶️', texthl = 'DapStopped', linehl = 'CursorLine' })
    vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#98c379' })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "go",
      callback = function()
        vim.keymap.set('n', '<Leader>dt', dapgo.debug_test, { desc = "Run Go test at cursor" })
      end,
      once = true
    })
  end,
}
