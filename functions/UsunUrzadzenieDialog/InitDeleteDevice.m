function InitDeleteDevice(app,mainApp)
% Used to initialize UsunUrzadzenieDialog
arguments
    app UsunUrzadzenieDialog
    mainApp ProjektSynchrofazory
end
            app.mainApp=mainApp;

            str=keys(mainApp.DataProvider.ListPMU);
            
            [~,columns]=size(str);
            items=cell(1,columns);
            for i=1:columns
                items{1,i}=num2str(cell2mat(str(1,i)));
            end
            app.DeviceList.Items=items;
end

