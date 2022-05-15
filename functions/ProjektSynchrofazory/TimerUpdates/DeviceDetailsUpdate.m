function DeviceDetailsUpdate(app)
%Used to update data inside of DeviceDetailsDialog
arguments
    app ProjektSynchrofazory
end
     if isvalid(app.DeviceDetailsDialog)
         UpdateData(app.DeviceDetailsDialog,app.DataProvider.ListPMU);
     end
end

