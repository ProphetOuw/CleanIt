export type CleanerType = {
    Add: (Entity: any) -> ();
    Destroy: (self: CleanerType) -> ();
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
            if CleanerFunctions[EntityType] or Entity["Destroy"] ~= nil then
                table.insert(Cleaner.Holder,Entity)
            else
                warn(`{Entity.Name}-{Entity.Class} has no cleaning support yet so it wasn't added to the cleaning list.`)
            end
        end;
        function Cleaner:Destroy()
            if self.Destroyed == true then warn("Cleaner is already destroyed"); return end;
            self.Destroyed = true;
            for i,v in pairs(Cleaner.Holder) do
                local vType = typeof(v)
                if vType == "table" and v["Destroy"] ~= nil then
                    vType = "Instance";
                end
                CleanerFunctions[vType](v)
            end
            for i,v in pairs(Cleaner.Holder) do
                Cleaner.Holder[i] = nil;
            end
            for i,v in pairs(Cleaner) do
                Cleaner[i] = nil;
            end
        end
        return Cleaner :: CleanerType
    end
}