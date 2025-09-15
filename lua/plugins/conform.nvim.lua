return {
	"stevearc/conform.nvim",
	opts = {
		-- NOTE: Install formatters with Mason
		formatters_by_ft = {
			-- Specify the linter for each programming language.
			lua = { "stylua" },
			c = { "clang-format" },
			cpp = { "clang-format" },
		    python = { "black" },
        },
		formatters = {
			ocamlformat = {
				prepend_args = {
					"--if-then-else",
					"vertical",
					"--break-cases",
					"fit-or-vertical",
					"--type-decl",
					"sparse",
				},
			},
		},
	},
}
