--!strict
local tins,tr,tc = table.insert,table.remove,table.clear
local tcancel = task.cancel

export type CleanerType = {
    Holder: {};
    Add: (Entity: any) -> ();
    Destroy: (self: CleanerType) -> ();
    Remove: (self: CleanerType, Entity: any) -> ();
    Clean: (self: CleanerType) -> ();
}


local mt = {}
mt.__index = mt;
function mt:Connect(Connection: RBXScriptSignal, func: () -> ())
    if Connection ~= nil and func ~= nil then
        tins(self,Connection:Connect(func))
    end
end
function mt:Add(Entity: any)
    if Entity == nil then return end;
    tins(self,Entity)
    return Entity;
end;
function mt:Remove(Entity)
    if Entity == nil then return end;
   local find = table.find(self,Entity)
   if find ~= nil then
    tr(self,find)
    return true;
   end
   
end
function mt:Clean()
    local i = #self
    while i >0 do
        local v: any = self[i];
        if v == nil then continue end;
        local type = typeof(v)
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
        self[i] = nil;
        i = #self;
    end
end
function mt:Destroy()
    self:Clean();
    setmetatable(self,nil);
end
return {
    New = function() : CleanerType
        local Cleaner = {
        } :: CleanerType;
        setmetatable(Cleaner,mt);
        return Cleaner :: any
    end
}