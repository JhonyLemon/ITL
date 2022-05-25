function ANALOG_Update(app)
%Used to update ANALOG plot
arguments
    app ProjektSynchrofazory
end
     if ishandle(app.ANALOG_figure) 
         if isvalid(app.ANALOG_figure)
             if ~isempty(app.DataProvider)
                 if ~isempty(app.DataProvider.PMUdetails.ANALOG) && ~isempty(app.DataProvider.PMUdetails.SOC)
                     set(0,'CurrentFigure',app.ANALOG_figure);
                     k=size(app.DataProvider.PMUdetails.ANALOG,1);
                     l=1;
                     x=app.DataProvider.PMUdetails.SOC;
                     hold on;
                     k1=keys(app.DataProvider.PMUdetails.ANALOG);
                     for m=1:size(app.DataProvider.PMUdetails.ANALOG)
                        key1=char(cell2mat(k1(m)));
                        subplot(k,1,l);
                        y=app.DataProvider.PMUdetails.ANALOG(key1);
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

