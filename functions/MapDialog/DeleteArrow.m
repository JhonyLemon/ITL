function DeleteArrow(app)
%Used to delete arrow from geoaxes
arguments
    app MapDialog
end
            Selected=app.ListOfAdded.Value;
            if isKey(app.MapOfAdded,Selected)
                remove(app.MapOfAdded,Selected);
                UpdateLists(app);
            end
end

