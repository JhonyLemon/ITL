function ModeSelection(app)
%Used to select mode in DodajUrzadzenieDialog
arguments
    app DodajUrzadzenieDialog
end
            selectedButton = app.TrybpracyButtonGroup.SelectedObject;
            switch selectedButton.Text
                case "Nasłuch"
                    app.WysyaniePanel.Enable="off";
                    app.Mode=CommunicationTypes.SpontaneousUDP;
                case "Standard"
                    app.WysyaniePanel.Enable="on";
                    app.Mode=CommunicationTypes.CommandedUDP;
            end
end

