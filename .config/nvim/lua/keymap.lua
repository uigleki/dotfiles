local keymaps = {}

keymaps['n'] = {                -- 普通模式
   [';'] = ':',
   ['q'] = ':q<cr>',
   ['f'] = 'i',                 -- 插入

   -- 移动
   ['i'] = 'k',
   ['j'] = 'h',
   ['k'] = 'j',
   ['l'] = 'l',

   -- 其他
   ['<leader>xc'] = ':q<cr>',
   ['<leader>xs'] = ':w<cr>',

   ['<leader>P'] = ':PackerSync<cr>',
}

keymaps['i'] = {                -- 插入模式
   ['<c-b>'] = '<left>',
   ['<c-f>'] = '<right>',
   ['<c-a>'] = '<home>',
   ['<c-e>'] = '<end>',
   ['<c-n>'] = '<down>',
   ['<c-p>'] = '<up>',
}

local function load_keymaps()
   vim.g.mapleader = ' '        -- 空格键作为 leader 键

   for mode, mode_map in pairs(keymaps) do
      for key, value in pairs(mode_map) do
         vim.api.nvim_set_keymap(mode, key, value, {noremap = true, silent = true})
      end
   end
end

load_keymaps()
