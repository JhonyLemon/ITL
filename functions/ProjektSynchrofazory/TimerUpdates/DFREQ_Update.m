function DFREQ_Update(app)
%Used to update DFREQ plot
arguments
    app ProjektSynchrofazory
end
             if ishandle(app.DFREQ_figure) 
                 if isvalid(app.DFREQ_figure)
                     if ~isempty(app.DataProvider)
                         if ~isempty(app.DataProvider.PMUdetails.DFREQ) && ~isempty(app.DataProvider.PMUdetails.SOC)
                             set(0,'CurrentFigure',app.DFREQ_figure);
                             x=app.DataProvider.PMUdetails.SOC;
                             y=app.DataProvider.PMUdetails.DFREQ(app.DataProvider.DeviceSTN);
                             hold on;
                             subplot(1,1,1);
                             if(size(x)==size(y))
                                plot(x,y,"Color",[0 0 0],"LineWidth",1);
                             end
                                title("DFREQ");
                             hold off;
                        end
                     end
                 end
             end
end

