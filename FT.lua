-- Copyright (c) 2014, Brax
-- All rights reserved.
-- 
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
--     * Redistributions of source code must retain the above copyright
--       notice, this list of conditions and the following disclaimer.
--     * Redistributions in binary form must reproduce the above copyright
--       notice, this list of conditions and the following disclaimer in the
--       documentation and/or other materials provided with the distribution.
--     * Neither the name of <addon name> nor the
--       names of its contributors may be used to endorse or promote products
--       derived from this software without specific prior written permission.
-- 
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL BRAX BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


_addon.name = 'FavouriteTarget'
_addon.version = '0.5'
_addon.author = 'Brax'
_addon.command = 'ft'

require('logger')
config = require('config')
texts = require('texts')

defaults = {}
defaults.target = 0
defaults.pos = {}
defaults.pos.x = 200
defaults.pos.y = 200
defaults.text = {}
defaults.text.font = 'Arial'
defaults.text.size = 12
settings = config.load(defaults)

ft = texts.new(settings)

windower.register_event('addon command', function(...)
    local args = T{...}
    if args[1] == nil then args[1] = 'help' end
	if args[1] == 'set' then
		settings.target = windower.ffxi.get_mob_by_target('t').id
	elseif args[1] == 'hide' then
		settings.target = 0
		ft:visible(false)
	end
end)

windower.register_event('prerender', function()
    local info = windower.ffxi.get_info()
    if not info.logged_in then
        ft:hide()
        return
    end
	if settings.target ~= 0 then
		info = windower.ffxi.get_mob_by_id(settings.target)
		if info then
			ft:text(info.name..':'..info.hpp..'%')
			ft:visible(true)
		end
	end
end)

