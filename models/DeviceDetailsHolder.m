classdef DeviceDetailsHolder < handle
    %DEVICEDETAILSHOLDER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        SOC
        FREQ
        DFREQ
        PHASOR0
        PHASOR1
        ANALOG
    end
    
    methods
        function obj = DeviceDetailsHolder()
            obj.SOC=datetime.empty();
            obj.FREQ=containers.Map("KeyType",'char','ValueType','any');
            obj.DFREQ=containers.Map("KeyType",'char','ValueType','any');
            obj.PHASOR0=containers.Map("KeyType",'char','ValueType','any');
            obj.PHASOR1=containers.Map("KeyType",'char','ValueType','any');
            obj.ANALOG=containers.Map("KeyType",'char','ValueType','any');
        end

        function delete(obj)
            delete(obj);
        end
    end
end

