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

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
    vim.keymap.set('n', '<Leader>dc', function() dap.continue() end)
    vim.keymap.set('n', 'Leader>di', function() dap.step_into() end)
    vim.keymap.set('n', '<Leader>dd', function()
      vim.keymap.set('n', 'n', function() dap.step_over() end)
      dap.step_over()
    end)
    vim.keymap.set('n', 'Leader>do', function() dap.step_out() end)
    vim.keymap.set('n', '<Leader>dt', function() dap.toggle_breakpoint() end)
    vim.keymap.set('n', '<Leader>ds', function() dap.set_breakpoint() end)
    vim.keymap.set('n', '<Leader>dx', function() dap.terminate() end)
  end,
}
