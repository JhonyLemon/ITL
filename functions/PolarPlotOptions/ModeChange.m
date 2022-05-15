function ModeChange(app)
%Used to activate proper panels in GUI
arguments
    app PolarPlotOptions
end
            selectedButton = app.OdniesieniedoButtonGroup.SelectedObject;
            app.ClearEnabled();
            if strcmp(selectedButton.Text,app.None.Text)
                app.Mode="None";
            elseif strcmp(selectedButton.Text,app.Default.Text)
                app.Mode="Default";
            elseif strcmp(selectedButton.Text,app.OtherPlotFreq.Text)
                app.WybierzIDPanel.Enable="on";
                app.Mode="OtherPMU";
            elseif strcmp(selectedButton.Text,app.CustomFreq.Text)
                app.CustomFreqPanel.Enable="on";
                app.Mode="CustomFreq";
            end
end

