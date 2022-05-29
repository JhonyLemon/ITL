function InitOptions(app,mainApp)
% Used to initialize UstawieniaDialog
arguments
    app UstawieniaDialog
    mainApp ProjektSynchrofazory
end
            app.MainApp = mainApp;
            app.CoilesekundodwieawykresySpinner.Value=mainApp.RefreshRate;
            app.sciezkaDoFolderu.Value=app.MainApp.DataProvider.pathToDatabase;
end

