--!strict
local tins,tr,tc = table.insert,table.remove,table.clear
local tcancel = task.cancel

export type CleanerType = {
    Holder: {};
    Add: (Entity: any) -> ();
    Destroy: (self: CleanerType) -> ();
    Remove: (Entity: any) -> ();
}

return {
    New = function()
        local Cleaner = {
            Holder = {};
        } :: CleanerType;
        Cleaner.Add = function(Entity: any)
            if Entity == nil then return end;
            tins(Cleaner.Holder,Entity)
        end;
        Cleaner.Remove = function(Entity)
            if Entity == nil then return end;
           local find = table.find(Cleaner.Holder,Entity)
           tr(Cleaner.Holder,find)
           return true;
        end
        function Cleaner:Destroy()
            for i,v: any in pairs (self.Holder) do
                self.Holder[i] = false;
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
            tc(self.Holder)
            tc(self)
        end
        return Cleaner
    end
}