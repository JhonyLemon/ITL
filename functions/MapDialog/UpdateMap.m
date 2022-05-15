function UpdateMap(app)
%UPDATEMAP Summary of this function goes here
arguments
    app MapDialog
end
    Latitude=[];
    Longitude=[];
    Angle=[];
    Magnitude=[];

    LatitudeLimit=[];
    LongitudeLimit=[];
    if ~isempty(app.LatLim1) && ~isempty(app.LatLim2) && ~isempty(app.LonLim1) && ~isempty(app.LonLim2)
        LatitudeLimit=[app.LatLim1 app.LatLim2];
        LongitudeLimit=[app.LonLim1 app.LonLim2];
    end

    k0=keys(app.MapOfAdded);
    for i=1:size(app.MapOfAdded)
       key0=char(cell2mat(k0(i)));
       handleToSubMap=app.MapOfAdded(key0);
       handle=app.mainApp.DataProvider.PolarPlotsMap(handleToSubMap.ID);
       handle1=handle(handleToSubMap.STN);

       Latitude(end+1)=handleToSubMap.Latitude;
       Longitude(end+1)=handleToSubMap.Longitude;
       Angle(end+1)=handle1.ang;
       Magnitude(end+1)=handle1.mag;
    end
    DrawOnGeoPlot(app.GeoAxes,Latitude,Longitude,Angle,Magnitude,LatitudeLimit,LongitudeLimit);
end

