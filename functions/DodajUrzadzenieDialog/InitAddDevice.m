function InitAddDevice(app,mainApp)
%Used to initialize DodajUrzadzeniaDialog
arguments
    app DodajUrzadzenieDialog
    mainApp ProjektSynchrofazory
end
            app.MainApp=mainApp;
            app.WysyaniePanel.Enable="off";
end

