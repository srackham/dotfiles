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
    vim.keymap.set('n', '<Leader>dc', dap.continue)
    vim.keymap.set('n', 'Leader>di', dap.step_into)
    vim.keymap.set('n', '<Leader>dd', function()
      vim.keymap.set('n', 'n', dap.step_over)
      dap.step_over()
    end)
    vim.keymap.set('n', 'Leader>do', dap.step_out)
    vim.keymap.set('n', '<Leader>dt', dap.toggle_breakpoint)
    vim.keymap.set('n', '<Leader>ds', dap.set_breakpoint)
    vim.keymap.set('n', '<Leader>dx', dap.terminate)
  end,
}
