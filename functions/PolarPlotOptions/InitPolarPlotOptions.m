function InitPolarPlotOptions(app,mainApp,ID)
%INIT Summary of this function goes here
arguments
    app PolarPlotOptions
    mainApp ProjektSynchrofazory
    ID
end
            app.mainApp=mainApp;
            app.ID=uint32(str2num(ID(1)));
            app.STN=char(ID(2));
            handle=mainApp.DataProvider.PolarPlotsMap(app.ID);
            handle=handle(app.STN);
            app.Mode=handle.Mode;
            k=1;
            items=cell(1,k);
            k0=keys(mainApp.DataProvider.PolarPlotsMap);
            for i=1:size(mainApp.DataProvider.PolarPlotsMap)
               key0=uint32(cell2mat(k0(i)));
               handleToSubMap=mainApp.DataProvider.PolarPlotsMap(key0);
               k1=keys(handleToSubMap);
               for j=1:size(handleToSubMap)
               key1=char(cell2mat(k1(j)));
               items{1,k}=char(string(key0)+"-"+string(key1));
               k=k+1;
               end
            end
            
            app.SelectOtherPlot.Items=items;


            switch app.Mode
                case ReferenceType.None
                    app.OdniesieniedoButtonGroup.SelectedObject=app.None;
                    ModeChange(app);
                case ReferenceType.Default
                    app.OdniesieniedoButtonGroup.SelectedObject=app.Default;
                    ModeChange(app);
                case ReferenceType.CustomFreq
                    app.OdniesieniedoButtonGroup.SelectedObject=app.CustomFreq;
                    if ~isempty(handle.Freq)
                        app.CustomFreqEdit.Value=handle.Freq;
                    end
                    ModeChange(app);
                case ReferenceType.OtherPMU
                    app.OdniesieniedoButtonGroup.SelectedObject=app.OtherPlotFreq;
                    if isKey(mainApp.DataProvider.PolarPlotsMap,handle.ID)
                        handleID=mainApp.DataProvider.PolarPlotsMap(handle.ID);
                        if isKey(handleID,handle.STN)
                            app.SelectOtherPlot.Value=string(string(handle.ID)+"-"+handle.STN);
                        end
                        
                    end
            end
            ModeChange(app);

end

