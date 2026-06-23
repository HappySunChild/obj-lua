---@param str string
---@param seperator string
---@return string[]
local function string_split(str, seperator)
	local tokens = {}

	for t in string.gmatch(str, string.format("[^%s]+", seperator)) do
		table.insert(tokens, t)
	end

	return tokens
end

---@class obj.ParsedObj
---@field v { x: number, y: number, z: number, w: number }[]
---@field vt { u: number, w: number, w: number }[]
---@field vn { x: number, y: number, z: number}[]
---@field vp { u: number, v: number?, w: number? }[]
---@field faces { v: number, vt: number?, vn: number? }[][]

---Parses a Wavefront `.obj` file as a list of lines and returns a [ParsedObj](lua://obj.ParsedObj) containing information about the 3D model.
---@param lines string[]
---@return obj.ParsedObj parsed_obj
local function parse(lines)
	local v = {}
	local vt = {}
	local vn = {}
	local vp = {}
	local faces = {}

	for _, line in ipairs(lines) do
		local args = string_split(line, "%s+")
		local name = args[1]

		if name == "v" then -- geometrix vertices
			table.insert(v, {
				x = tonumber(args[2]),
				y = tonumber(args[3]),
				z = tonumber(args[4]),
				w = tonumber(args[5]) or 1,
			})
		elseif name == "vt" then -- texture coordinates
			table.insert(vt, {
				u = tonumber(args[2]),
				v = tonumber(args[3]),
				w = tonumber(args[4]) or 1,
			})
		elseif name == "vn" then -- vertex normals
			table.insert(vn, {
				x = tonumber(args[2]),
				y = tonumber(args[3]),
				z = tonumber(args[4]),
			})
		elseif name == "vp" then -- parameter space vertices
			table.insert(vp, {
				u = tonumber(args[2]),
				v = tonumber(args[3]),
				w = tonumber(args[4]),
			})
		elseif name == "f" then -- polygonal faces
			local face = {}

			for i = 2, #args do
				local vert_args = string_split(args[i], "/")

				table.insert(face, {
					v = tonumber(vert_args[1]),
					vt = tonumber(vert_args[2]),
					vn = tonumber(vert_args[3]),
				})
			end

			table.insert(faces, face)
		end
	end

	return {
		v = v,
		vt = vt,
		vn = vn,
		vp = vp,
		faces = faces,
	}
end

---Loads and parses a Wavefront `.obj` file with the specified path.
---@param path string
---@return obj.ParsedObj parsed_obj
local function load(path)
	local lines = {}

	for line in io.lines(path) do
		table.insert(lines, line)
	end

	return parse(lines)
end

return {
	parse = parse,
	load = load,
}
