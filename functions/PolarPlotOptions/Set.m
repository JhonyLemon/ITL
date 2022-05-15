function Set(app)
%Used set selected mode for polar plot
arguments
    app PolarPlotOptions
end
            stop(app.mainApp.Timer);
            handle=app.mainApp.DataProvider.PolarPlotsMap(app.ID);
            handle=handle(app.STN);
            handle.Mode=app.Mode;
            id=split(app.SelectOtherPlot.Value,"-");
            handle.ID=uint32(str2double(id(1)));
            handle.STN=char(id(2));
            handle.Freq=app.CustomFreqEdit.Value;
            start(app.mainApp.Timer);
            delete(app);
end

