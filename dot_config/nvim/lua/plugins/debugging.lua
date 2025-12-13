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

    -- Deno vscode-js-debug debugger registration
    -- See https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#javascript-deno)
    dap.adapters['pwa-node'] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = {
        command = 'js-debug',
        args = { '${port}' },
      }
    }
    -- Deno debugging launch configurations for TypeScript files
    dap.configurations.typescript = {
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch Deno Application (current file)',
        runtimeExecutable = 'deno',
        runtimeArgs = {
          'run',
          '--inspect-wait',
          '--allow-all'
        },
        program = '${file}',
        cwd = '${workspaceFolder}',
        attachSimplePort = 9229,
      },
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch Deno Tests (current file)',
        runtimeExecutable = 'deno',
        runtimeArgs = {
          'test',
          '--inspect-wait',
          '--allow-all'
        },
        program = '${file}',
        cwd = '${workspaceFolder}',
        attachSimplePort = 9229,
      },
    }

    -- Configure dap-ui layout
    dapui.setup({
      -- icons = { expanded = '▾', collapsed = '▸' },
      mappings = {
        open = 'o',
        remove = 'd',
        edit = 'e',
        repl = 'r',
        toggle = 't',
      },
      layouts = {
        {
          elements = {
            { id = 'scopes', size = 0.25 },
            'breakpoints',
            'stacks',
            'watches',
          },
          size = 0.4,
          position = 'left',
        },
        {
          elements = { 'repl', 'console' },
          size = 0.25,
          position = 'bottom',
        },
      },
    })

    -- Attach the UI to `nvim-dap` plugin.
    dap.listeners.before.attach.dapui_config = dapui.open
    dap.listeners.before.launch.dapui_config = dapui.open
    dap.listeners.before.event_terminated.dapui_config = dapui.close
    dap.listeners.before.event_exited.dapui_config = dapui.close

    vim.keymap.set('n', '<Leader>dc', function()
      vim.cmd('wa')
      dap.continue()
    end, { desc = "Debug start or continue" })
    vim.keymap.set('n', '<Leader>ds', dap.step_over, { desc = "Debug step over" })
    vim.keymap.set('n', '<C-n>', dap.step_over, { desc = "Debug step over" })
    vim.keymap.set('n', '<Leader>di', dap.step_into, { desc = "Debug step into" })
    vim.keymap.set('n', '<Leader>dj', dap.focus_frame, { desc = "Jump to debug cursor" })
    vim.keymap.set('n', '<Leader>do', dap.step_out, { desc = "Debug step out" })
    vim.keymap.set('n', '<Leader>dr', dap.run_to_cursor, { desc = "Run to cursor" })
    vim.keymap.set('n', '<Leader>dR', function()
      vim.cmd('wa')
      dap.restart()
    end, { desc = "Restart the debug session" })
    vim.keymap.set('n', '<Leader>db', dap.toggle_breakpoint, { desc = "Toggle debug breakpoint" })
    vim.keymap.set('n', '<Leader>dB', function()
      dap.clear_breakpoints(); vim.notify("Cleared all breakpoints")
    end, { desc = "Clear all breakpoints" })
    vim.keymap.set({ 'n', 'v' }, '<Leader>de', function() dapui.eval() end, { desc = "Evaluate expression" })
    vim.keymap.set('n', '<Leader>du', dapui.toggle, { desc = "Toggle debug UI" })
    vim.keymap.set('n', '<Leader>dU', function() dapui.open({ reset = true }) end,
      { desc = "Open and reinitialize the debug UI" })
    vim.keymap.set('n', '<Leader>df', function()
      dapui.float_element('scopes', {
        width = 200,
        height = 50,
        enter = true,
        position = 'center'
      })
    end, { desc = "Open a floating scopes window" })
    vim.keymap.set('n', '<Leader>dw', function()
      dapui.float_element('watches', {
        width = 200,
        height = 50,
        enter = true,
        position = 'center'
      })
    end, { desc = "Open a floating watches window" })
    vim.keymap.set('n', '<Leader>dx', dap.terminate, { desc = "Terminate debug session" })

    vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DapBreakpoint' })
    vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = 'red' })
    vim.fn.sign_define('DapStopped', { text = '▶️', texthl = 'DapStopped', linehl = 'CursorLine' })
    vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#98c379' })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "go",
      callback = function()
        vim.keymap.set('n', '<Leader>dt',
          function()
            vim.cmd('wa')
            dapgo.debug_test()
          end, { desc = "Run Go test at cursor" })
      end,
      once = true
    })
  end,
}
