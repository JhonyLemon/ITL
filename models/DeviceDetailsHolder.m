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
            obj.FREQ=[];
            obj.DFREQ=[];
            obj.PHASOR0=[];
            obj.PHASOR1=[];
            obj.ANALOG=[];
        end

        function delete(obj)
            delete(obj);
        end
    end
end

