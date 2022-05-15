function SetLimits(app)
%SETLIMITS Summary of this function goes here
arguments
    app MapDialog
end
    if app.LatitudeY1.Value<app.LatitudeY2.Value && app.LongitudeX1.Value<app.LongitudeX2.Value
        app.LatLim2=app.LatitudeY2.Value;
        app.LonLim2=app.LongitudeX2.Value;
        app.LatLim1 =app.LatitudeY1.Value;
        app.LonLim1 =app.LongitudeX1.Value;
    end
end

