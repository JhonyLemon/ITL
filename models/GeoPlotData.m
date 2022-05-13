classdef GeoPlotData < handle
    %GEOPLOTDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Latitude
        Longitude
        ID
        STN
    end
    
    methods
        function obj = GeoPlotData(Latitude,Longitude,ID,STN)
            %GEOPLOTDATA Construct an instance of this class
            %   Detailed explanation goes here
            obj.Latitude=Latitude;
            obj.Longitude=Longitude;
            obj.ID=ID;
            obj.STN=STN;
        end
    end
end

