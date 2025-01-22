--!strict
export type CleanerType = {
    Add: (Entity: any) -> ();
    Destroy: (self: CleanerType) -> ();
    Remove: (Entity: any) -> ();
}
local CleanerFunctions = {
    ["function"]= function(object)
        object();
    end;
    ["Instance"] = function(object)
        object:Destroy()
    end;
    ["RBXScriptConnection"] = function(object)
        object:Disconnect()
    end;
    ["thread"] = function(object)
        task.cancel(object)
    end;
    ["table"] = function(object)
        for k in pairs(object) do
            object[k] = nil
        end
    end;
};
return {
    New = function()
        local Cleaner = {
            Holder = {};
        };
        Cleaner.Add = function(Entity: any)
            if Entity == nil then return end;
            local EntityType = typeof(Entity)
            if CleanerFunctions[EntityType] or (EntityType == "talbe" and Entity["Destroy"] ~= nil) then
                table.insert(Cleaner.Holder,Entity)
            else
                warn(`{Entity.Name}-{Entity.Class} has no cleaning support yet so it wasn't added to the cleaning list.`)
            end
        end;
        Cleaner.Remove = function(Entity)
            if Entity == nil then return end;
           local find = table.find(Cleaner.Holder,Entity)
           table.remove(Cleaner.Holder,find)
           return true;
        end
        function Cleaner:Destroy()
            for i,v in (Cleaner.Holder) do
                local vType = typeof(v)
                if vType == "table" and v["Destroy"] ~= nil then
                    vType = "Instance";
                end
                CleanerFunctions[vType](v)
            end
            for k in (Cleaner.Holder) do
                Cleaner.Holder[k] = nil;
            end
            for k in (Cleaner) do
                Cleaner[k] = nil;
            end
        end
        return Cleaner :: CleanerType
    end
}