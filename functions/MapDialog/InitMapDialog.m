function InitMapDialog(app,mainApp)
%Used to initialize MapDialog
arguments
    app MapDialog
    mainApp ProjektSynchrofazory
end
    app.GeoAxes=geoaxes();
    app.mainApp=mainApp;

    app.MapOfAdded = containers.Map("KeyType",'char','ValueType','any');
    
    UpdateLists(app);
end

