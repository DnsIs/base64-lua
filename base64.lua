base64 = {
	__version = '0.3',
	encrypt = function(s)
		local byte = string.byte;
		local k = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
		local a, b, i, e = {}, {};
		i = (-#s) % 3;
		s, e = s .. string.rep('\x00', i), string.rep('=', i)

		for i = 1, #s, 3 do
			local c1, c2, c3, n = byte(s, i, i + 2)
			n = c1 * 2^16 + c2 * 2^8 + c3
			b[#b+1] = (n >> 18) + 1;
			b[#b+1] = ((n >> 12) & 63) + 1;
			b[#b+1] = ((n >> 6) & 63) + 1;
			b[#b+1] = (n & 63) + 1;
		end

		for i = 1, #b do a[#a+1] = k:sub(b[i], b[i]) end
		s = table.concat(a)
		return s:sub(1, #s - #e) .. e
	end
,
	decrypt = function(s)
		local char = string.char;
		local k = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
		local a, e, i, c1, c3, c3, c4 = {};
		local _, e = s:sub(2):gsub('=', '')
		s = s:gsub("[^0-9A-z//+]", ""):gsub("[\x0d\x0a]", "")
		for i = 1, #s, 4 do
			c1 = k:find( s:sub(i, i) ) - 1
			c2 = k:find( s:sub(i + 1, i + 1) ) - 1
			c3 = k:find( s:sub(i + 2, i + 2) ) - 1
			c4 = k:find( s:sub(i + 3, i + 3) ) - 1
			a[#a+1] = char( (c1 << 2) | (c2 >> 4) )
			a[#a+1] = char( ((c2 & 15) << 4) | (c3 >> 2) )
			a[#a+1] = char( ((c3 & 3) << 6) | c4 )
		end
		s = table.concat(a)
		s = s:sub(1, #s-e);
		return (s)
	end
}

local toBase64 = base64.encrypt('Man is distinguished, not only by his reason, but by this singular passion from other animals, which is a lust of the mind, that by a perseverance of delight in the continued and indefatigable generation of knowledge, exceeds the short vehemence of any carnal pleasure.');
local fromBase64 = base64.decrypt(toBase64);
print(toBase64)
print(fromBase64)
