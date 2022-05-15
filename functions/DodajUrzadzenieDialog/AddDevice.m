function AddDevice(app)
%Used to add deivce to program

            IsIpValid=false;
            IsIdValid=false;
            IsPortValid=false;
            [Num, N] = sscanf(app.IpEditField.Value, '%d.%d.%d.%d');
            if N==4 && (all(Num))>=0 && (all(Num))<256
                IsIpValid=true;
            else
                IsIpValid=false;
                app.IpEditField.FontColor=[1.00,0.00,0.00];
            end

            if  ~isempty(app.IdEditField.Value) && ~isKey(app.MainApp.DataProvider.ListPMU,app.IdEditField.Value)
                IsIdValid=true;
            else
                IsIdValid=false;
                app.IdEditField.FontColor=[1.00,0.00,0.00];
            end

            if ~isempty(app.PortEditField.Value)
                IsPortValid=true;
            else
                IsPortValid=false;
                app.PortEditField.FontColor=[1.00,0.00,0.00];
            end

            if app.Mode==CommunicationTypes.CommandedUDP
                [Num, N] = sscanf(app.IpEditField_2.Value, '%d.%d.%d.%d');
                if N==4 && (all(Num))>=0 && (all(Num))<256
                    IsIpValid=true;
                else
                    IsIpValid=false;
                    app.IpEditField_2.FontColor=[1.00,0.00,0.00];
                end
                if ~isempty(app.PortEditField_2.Value)
                    IsPortValid=true;
                else
                    IsPortValid=false;
                    app.PortEditField_2.FontColor=[1.00,0.00,0.00];
                end
            end


            if IsIpValid==true && IsIdValid==true && IsPortValid==true
                app.MainApp.DataProvider.AddNewPMU(PMU(app.IpEditField.Value,uint16(app.PortEditField.Value),uint16(app.IdEditField.Value),"CommunicationType",app.Mode));
                delete(app);
            end

end

