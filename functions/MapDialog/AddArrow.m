function AddArrow(app)
%ADDARROW Summary of this function goes here
arguments
    app MapDialog
end
    if app.LatitudePointY.Value~=0 && app.LongitudePointX.Value~=0
        location=strfind(app.ListOfAvaliable.Value,"-");
        id=uint32(str2num(char(cell2mat(extractBetween(app.ListOfAvaliable.Value,1,location(1)-1)))));
        stn=char(cell2mat(extractBetween(app.ListOfAvaliable.Value,location(1)+1,size(app.ListOfAvaliable.Value,2))));
        handle=GeoPlotData(app.LatitudePointY.Value,app.LongitudePointX.Value,id,stn(1,:));
        app.MapOfAdded(char(app.ListOfAvaliable.Value))=handle;
        UpdateLists(app);
        app.LatitudePointY.Value=0;
        app.LongitudePointX.Value=0;
    end
end

