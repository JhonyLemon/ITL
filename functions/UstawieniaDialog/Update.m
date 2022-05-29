function Update(app)
%Used to change timer interval
arguments
    app UstawieniaDialog
end
    app.MainApp.RefreshRate=app.CoilesekundodwieawykresySpinner.Value;
    stop(app.MainApp.Timer);
    app.MainApp.Timer=InitTimer(app.MainApp);
    start(app.MainApp.Timer);
    if exist(app.sciezkaDoFolderu.Value,"dir")==7
        app.MainApp.DataProvider.pathToDatabase=app.sciezkaDoFolderu.Value;
    end
    app.MainApp.DataProvider.openDataBase();
    delete(app);
end

