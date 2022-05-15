function t=InitTimer(app)
%Used to initialize timer
arguments
    app ProjektSynchrofazory
end
    t = timer;

    t.TimerFcn = @(src,evt) TimerCallback(app,src,evt);

    t.Period = app.RefreshRate;

    t.TasksToExecute = Inf;
    t.ExecutionMode = 'fixedRate';
end

