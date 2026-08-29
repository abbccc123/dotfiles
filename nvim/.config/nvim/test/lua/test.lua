#!/usr/bin/env lua


local reversed_list = vim.fn.reverse({ 'a', 'b', 'c' })
vim.print(reversed_list) -- { "c", "b", "a" }
