function FREQ_Update(app)
%Used to update FREQ plot
arguments
    app ProjektSynchrofazory
end
     if ishandle(app.FREQ_figure) 
         if isvalid(app.FREQ_figure)
             if ~isempty(app.DataProvider)
                 if ~isempty(app.DataProvider.PMUdetails.FREQ) && ~isempty(app.DataProvider.PMUdetails.SOC)
                     set(0,'CurrentFigure',app.FREQ_figure);
                     x=app.DataProvider.PMUdetails.SOC;
                     y=app.DataProvider.PMUdetails.FREQ(app.DataProvider.DeviceSTN);
                     hold on;
                     subplot(1,1,1);
                     plot(x,y',"Color",[0 0 0],"LineWidth",1);
                        title("FREQ");
                     hold off;
                end
             end
         end
     end
end

