export type CleanerType = {
    Add: (Entity: any, CleanerFunction: string) -> ();
    Destroy: (self: CleanerType) -> ();
}
local CleanerFunctions = {
    ["function"]= function(object)
        object();
    end;
    ["Instance"] = function(object)
        object:Destroy()
    end;
    "Default"
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
                warn(`{Entity.Name}-{Entity.Class} has no cleaning support yet so it wasn't added to the cleaning queu.`)
            end
        end;
        function Cleaner:Destroy()
            
        end
        return Cleaner :: CleanerType
    end
}