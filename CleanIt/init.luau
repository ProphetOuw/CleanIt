--!strict
local tins,tr,tc = table.insert,table.remove,table.clear
local tcancel = task.cancel

export type CleanerType = {
    Holder: {};
    Add: (Entity: any) -> ();
    Destroy: (self: CleanerType) -> ();
    Remove: (Entity: any) -> ();
}


local mt = {}
mt.__index = mt;
function mt:Add(Entity: any)
    if Entity == nil then return end;
    tins(self,Entity)
end;
function mt:Remove(Entity)
    if Entity == nil then return end;
   local find = table.find(self,Entity)
   if find ~= nil then
    tr(self,find)
    return true;
   end
   
end
function mt:Destroy()
    for i,v: any in pairs (self) do
        self[i] = false;
        local type = typeof(v)
        if type == "table" and v["Destroy"] ~= nil then
            type = "Instance";
        end
        if (type == "table" and v["Destroy"] ~= nil) or type == "Instance" then
            v:Destroy();
        elseif type == "function" then
            v()
        elseif type == "RBXScriptConnection" then
            v:Disconnect();
        elseif type == "thread" then
            tcancel(v);
        elseif type == "table" then
            tc(v)
        end
    end
    tc(self)
end
return {
    New = function()
        local Cleaner = {
        } :: CleanerType;
        setmetatable(Cleaner,mt);
        return Cleaner
    end
}