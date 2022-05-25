function MAGNITUDE_Update(app)
%Used to update MAGNITUDE plot
arguments
    app ProjektSynchrofazory
end
    if ishandle(app.MAGNITUDE_figure) 
         if isvalid(app.MAGNITUDE_figure)
             if ~isempty(app.DataProvider)
                 if ~isempty(app.DataProvider.PMUdetails.PHASOR0) && ~isempty(app.DataProvider.PMUdetails.SOC)
                     set(0,'CurrentFigure',app.MAGNITUDE_figure);
                     k=size(app.DataProvider.PMUdetails.PHASOR0,1);
                     l=1;
                     x=app.DataProvider.PMUdetails.SOC;
                     hold on;
                     k1=keys(app.DataProvider.PMUdetails.PHASOR0);
                     for m=1:size(app.DataProvider.PMUdetails.PHASOR0)
                        key1=char(cell2mat(k1(m)));
                        subplot(k,1,l);
                        y=app.DataProvider.PMUdetails.PHASOR0(key1);
                        if(size(x)==size(y))
                            plot(x,y,"Color",[0 0 0],"LineWidth",1);
                        end
                        l=l+1;
                        title(string(app.DataProvider.DeviceSTN)+"-"+string(key1));
                     end
                     hold off;
                  end
             end
         end
     end
end

