function Delete(app)
%Used to delete device from added
arguments
    app UsunUrzadzenieDialog
end
    stop(app.mainApp.Timer)
    app.mainApp.DataProvider.DeletePMU(uint32(str2double(app.DeviceList.Value)));
    start(app.mainApp.Timer)
    delete(app);
end

