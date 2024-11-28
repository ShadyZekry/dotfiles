local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node
local f = ls.function_node
local sn = ls.snippet_node
local fmta = require("luasnip.extras.fmt").fmta

local generateParameterDocs = function(args)
	local parameters = args[1][1]
	if parameters == "" then
		return sn(nil, {})
	end

	parameters = vim.split(parameters, ",")
	parameters = vim.tbl_map(function(p)
		return " * @param " .. vim.trim(p)
	end, parameters)

	-- add a newline at the start of the table
	table.insert(parameters, 1, " *")
	table.insert(parameters, 1, "")
	return sn(nil, t(parameters))
end

local generatereturnDocs = function(args)
	return sn(nil, {})
end

ls.add_snippets("php", {
	s(
		"fn",
		fmta(
			[[
/**
 * <description><param_doc><return_doc>
 */
<access> function <name>(<parameters>)<returns>
{
	<finish>
}
		]],
			{
				access = c(1, {
					t("private"),
					t("protected"),
					t("public"),
				}),
				name = i(2, "name"),
				parameters = i(3),
				param_doc = d(4, generateParameterDocs, { 3 }),
				description = i(5, "description"),
				returns = i(6),
				return_doc = d(7, generatereturnDocs, { 6 }),
				finish = i(0),
			}
		)
	),

	s({
		name = "PHP foreach loop",
		dscr = "Generate a PHP foreach loop for an array",
		trig = "%$(%w+)%.4ech",
		regTrig = true,
	}, {
		f(function(_, snip)
			local array_name = snip.captures[1]
			return "foreach ($" .. array_name .. " as $"
		end, {}),
		i(1, "key"),
		t(" => $"),
		i(2, "value"),
		t({ ") {", "\t" }),
		i(3),
		t({ "", "}" }),
	}),

	s({ name = "PHP for loop", dscr = "Generate a PHP loop", trig = "for" }, {
		t("for ($i = 0; $i <= $"),
		i(1, "n"),
		t("; $i++) {"),
		t({ "", "\t" }),
		i(2),
		t({ "", "}" }),
	}),
})
