local json = require "cjson.safe"
local const = require "module.const"
local db = require "module.db"
local req = require "module.req"

local post_id = ngx.ctx.body_data.post_id

local referer = ngx.var.http_referer
local valid_referer = "/p/" .. post_id .. ".html"
local valid_result = req.valid_http_referer(referer, valid_referer)
if not valid_result then
    return req.bad_request()
end

if type(post_id) ~= "number" then
    ngx.log(ngx.ERR, "[post random] post_id type ~= number#", type(post_id))
    return req.bad_request()
end

local result = db.query([[
select id, title, pv from post where post_status=0 order by random() limit 10
]])

local res = const.ok({ post = result })
ngx.say(json.encode(res))
