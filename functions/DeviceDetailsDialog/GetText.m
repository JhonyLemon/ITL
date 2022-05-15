function text=GetText(app,array)
arguments
    app DeviceDetailsDialog
    array
end
    text="";
    [~,j]=size(array);
    for n=1:j
        text=text+" "+strip(replace(string(array(app.index,n)),char(0x00),' '));
    end
end

