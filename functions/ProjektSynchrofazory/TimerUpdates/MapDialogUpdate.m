function MapDialogUpdate(app)
%Used to update data inside of MapDialog
arguments
    app ProjektSynchrofazory
end
     if isvalid(app.MapDialog)
         UpdateMap(app.MapDialog);
     end
end

