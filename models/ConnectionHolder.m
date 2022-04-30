classdef ConnectionHolder < handle
    %CONNECTIONHOLDER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        IDs
        Connection
    end
    
    methods
        function obj = ConnectionHolder(Connection,IDs)
            obj.Connection=Connection;
            obj.IDs=IDs;
        end
        function delete(obj)
            delete(obj.Connection);
        end

    end
end

