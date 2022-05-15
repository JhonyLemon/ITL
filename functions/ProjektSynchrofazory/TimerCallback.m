function TimerCallback(app, ~, ~)
%Callback method for main timer
arguments
    app ProjektSynchrofazory
    ~
    ~
end
FREQ_Update(app);
DFREQ_Update(app);
MAGNITUDE_Update(app);
PHASE_Update(app);
ANALOG_Update(app);
DeviceDetailsUpdate(app);
PolarPlotsUpdate(app);
MapDialogUpdate(app);
end

