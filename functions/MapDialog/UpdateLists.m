function UpdateLists(app)
%Used to update lists inside of MapDialog
arguments
    app MapDialog
end
    k=1;
    items=cell(1,k);
    k0=keys(app.mainApp.DataProvider.PolarPlotsMap);
    for i=1:size(app.mainApp.DataProvider.PolarPlotsMap)
       key0=uint32(cell2mat(k0(i)));
       handleToSubMap=app.mainApp.DataProvider.PolarPlotsMap(key0);
       k1=keys(handleToSubMap);
       for j=1:size(handleToSubMap)
            key1=char(cell2mat(k1(j)));
            key2=char(string(key0)+"-"+string(key1));
            
            if ~isKey(app.MapOfAdded,key2)
                items{1,k}=key2;
                k=k+1;
            end
       end
    end
    
    if size(items,2)>0 && size(items{1,1},2)>0
        app.ListOfAvaliable.Items=items;
    else
        app.ListOfAvaliable.Items={};
    end

    k=1;
    items=cell(1,k);
    k0=keys(app.MapOfAdded);
    for i=1:size(app.MapOfAdded)
       key0=char(cell2mat(k0(i)));
       items{1,k}=key0;
       k=k+1;
    end
    
    if size(items,2)>0 && size(items{1,1},2)>0
        app.ListOfAdded.Items=items;
    else
        app.ListOfAdded.Items={};
    end
end

