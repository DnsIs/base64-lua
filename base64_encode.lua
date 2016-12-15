function EncodeToBase64 (s)
	local b = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
		'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
		'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
		'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
		'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
		'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
		'w', 'x', 'y', 'z', '0', '1', '2', '3',
		'4', '5', '6', '7', '8', '9', '+', '/'
	}
	local c, a, byte = 76, {}, string.byte
	if #s%3 == 1 then
		s, e = s.."\x00\x00", "=="
	elseif #s%3 == 2 then
		s, e = s.."\x00", "="
	else
		e = ""
	end
	for i = 1, #s, 3 do
		local c1, c2, c3 = byte(s, i), byte(s, i+1), byte(s, i+2)
		a[#a+1] = b[(c1>>2)+1]
		a[#a+1] = b[(((c1&0x3)<<4) | (c2>>4))+1]
		a[#a+1] = b[(((c2&15)<<2) | (c3>>6))+1]
		a[#a+1] = b[(c3&63)+1]
		c = c - 4
		if c == 0 then
			a[#a+1] = "\x0D\x0A"
			c = 76
		end
	end
	s = table.concat(a)
	return (s:sub(1, #s - #e) .. e)
end
--------------------------------------------------------------------------------
if arg[1] then
	opt = {}
	if arg[1]:match("\\") then
		opt.dir, opt.input = arg[1]:match("(.*\\)(.*)")
		opt.output = opt.input .. ".b64"
	else
		opt.dir, opt.input, opt.output = io.popen("cd"):read'*l'.."\\", arg[1], arg[1] .. ".b64"
	end
else
	print ("usage: lua base64_encode.lua FILE")
end

t = os.time()

local f = io.open(opt.dir..opt.input, "rb")
s = f:read("a")
f:close()

s = EncodeToBase64 (s)
local f = io.open(opt.dir..opt.output, "wb")
f:write('MIME-Version: 1.0\r\nContent-Type: application/octet-stream; name="' .. opt.input ..'"\r\n')
f:write('Content-Transfer-Encoding: base64\r\nContent-Disposition: attachment; filename="' .. opt.input ..'"\r\n\r\n')
f:write(s)
f:write('\r\n\r\n')
f:close()

print("encode " .. opt.input .. " at\t" .. os.time()-t .. " sec")
