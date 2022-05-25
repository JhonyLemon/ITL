classdef ListOfPMU < handle
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here

    properties
    appHandle ProjektSynchrofazory
    ListPMU; % map of PMU devices that we listen for
    UDPconnections% used to handle UDP connections
    PMUdetails
    DeviceID
    DeviceSTN
    PolarPlotsMap
    dbFile
    connection
    dbTemp

    end

    methods
        function obj = ListOfPMU(app)
            obj.appHandle=app;
            obj.PolarPlotsMap = containers.Map("KeyType",'uint32','ValueType','any');
            obj.ListPMU = containers.Map("KeyType",'uint32','ValueType','any');
            obj.UDPconnections=ConnectionHolder.empty;
            obj.PMUdetails=DeviceDetailsHolder();

            
                     obj.dbFile = "bazaITL.db";
                     if isfile(obj.dbFile)
                         obj.connection = sqlite(obj.dbFile, "connect");
                     else
                         obj.connection = sqlite(obj.dbFile, "create");
                     end
 
                     obj.connection.AutoCommit = 'off';

            obj.dbTemp=DataFrame.empty;
        end

        function openNewUdp(obj,PMU)
            DoWeNeedNewPort=true;
            handleForSocket=[];
            for i=1:size(obj.UDPconnections)
                if isempty(obj.UDPconnections)
                    break;
                end
                handle = obj.UDPconnections(i);
                if strcmp(handle.Connection.LocalHost,PMU.LocalHost) && handle.Connection.LocalPort==PMU.LocalPort
                    DoWeNeedNewPort=false;
                    handleForSocket=handle;
                    break;
                end
            end
            if DoWeNeedNewPort==true
                handleForSocket=udpport("datagram","Ipv4","LocalPort",PMU.LocalPort,"LocalHost",PMU.LocalHost,"OutputDatagramSize",65507,"EnablePortSharing",true);
                handleForSocket.configureCallback("datagram",1,@(src,evt) UdpCallback(obj,src,evt));
                obj.UDPconnections(end+1)=ConnectionHolder(handleForSocket,PMU.ID);
            else
                handleForSocket.IDs(end+1)=PMU.ID;
            end
        end

        function UdpCallback(obj,src,~)
                frame=read(src,1,"uint8");%read data from socket
                ID=uint32(swapbytes(typecast(uint8(frame.Data(5:6)),'uint16')));%check ID of recived frame
                if obj.ListPMU.isKey(ID)%if ID from frame is in map
                    handle=obj.ListPMU(ID);
                    handle.InsertFrame(frame);%parse frame
                    %%
                    %Wpis do bazy
                if ~isempty(handle.data)
                     obj.dbTemp(end+1)=handle.data;
                     if(size(obj.dbTemp,2)>10)
                         DataBaseWrite(obj.connection,obj.dbTemp);
                         obj.dbTemp=DataFrame.empty;
                     end
                end
                    %%
                    if handle.cnf_version==2 || handle.cnf_version==1
                        if ~isempty(handle.cnf)
                            obj.CreateNewPlot(handle.cnf);
                        end
                    elseif handle.cnf_version == 3
                    end
                        if ~isempty(obj.DeviceID) && ~isempty(handle.data) && obj.DeviceID==ID
                            if isKey(obj.PolarPlotsMap,obj.DeviceID)
                                handleToSubMap=obj.PolarPlotsMap(obj.DeviceID);
                                if isKey(handleToSubMap,obj.DeviceSTN)
                                    handleData=handle.data;
                                    obj.PMUdetails.SOC(end+1)=handleData.SOC;

                                    freq=[];
                                    if isKey(obj.PMUdetails.FREQ,obj.DeviceSTN)
                                        freq=obj.PMUdetails.FREQ(obj.DeviceSTN);
                                    end
                                    freq(end+1)=handleData.FREQ(obj.DeviceSTN);
                                    obj.PMUdetails.FREQ(obj.DeviceSTN)=freq;

                                    dfreq=[];
                                    if isKey(obj.PMUdetails.DFREQ,obj.DeviceSTN)
                                        dfreq=obj.PMUdetails.DFREQ(obj.DeviceSTN);
                                    end
                                    dfreq(end+1)=handleData.DFREQ(obj.DeviceSTN);
                                    obj.PMUdetails.DFREQ(obj.DeviceSTN)=dfreq;
                    

                                    phs0=handleData.PHASORS0(obj.DeviceSTN);
                                    phs1=handleData.PHASORS1(obj.DeviceSTN);
                                    ana=handleData.ANALOG(obj.DeviceSTN);

                                   k1=keys(phs0);
                                   for j=1:size(phs0)
                                        key1=char(cell2mat(k1(j)));
                                        phasor0=[];
                                        phasor1=[];
                                        if isKey(obj.PMUdetails.PHASOR0,key1)
                                            phasor0=obj.PMUdetails.PHASOR0(key1);
                                        end
                                        if isKey(obj.PMUdetails.PHASOR1,key1)
                                            phasor1=obj.PMUdetails.PHASOR1(key1);
                                        end

                                         phasor0(end+1)=phs0(key1);
                                         phasor1(end+1)=phs1(key1);

                                         obj.PMUdetails.PHASOR0(key1)=phasor0;
                                         obj.PMUdetails.PHASOR1(key1)=phasor0;
                                   end

                                   k1=keys(ana);
                                   for j=1:size(ana)
                                        key1=char(cell2mat(k1(j)));
                                        analog=[];
                                        if isKey(obj.PMUdetails.ANALOG,key1)
                                            analog=obj.PMUdetails.ANALOG(key1);
                                        end
                                        analog(end+1)=ana(key1);
                                        obj.PMUdetails.ANALOG(key1)=analog;
                                   end
                                end
                            end
                        end
                end
        end

        function UpdatePlots(obj)
            k0=keys(obj.PolarPlotsMap);
            for i=1:size(obj.PolarPlotsMap)
               key0=uint32(cell2mat(k0(i)));
               handleToSubMap=obj.PolarPlotsMap(key0);
               k1=keys(handleToSubMap);
               for j=1:size(handleToSubMap)
               key1=char(cell2mat(k1(j)));
               handleToPolarPlots=handleToSubMap(key1);
               handleToPMU=obj.ListPMU(key0);
               handleToPolarPlots.UpdateGraph(handleToPMU,obj.PolarPlotsMap);
               end
            end
        end

        function CreateNewPlot(obj,handleCNF)
            arguments
                obj ListOfPMU
                handleCNF ConfigFrame
            end
            PLOTS=containers.Map("KeyType",'char','ValueType','any');
            [col,~]=size(handleCNF.STN);
            for i=1:col
                if ~isKey(obj.PolarPlotsMap,handleCNF.ID_CODE_DATA(i))
                   handlePlot=CustomPolarPlot(obj.appHandle.GridForPlots);
                   handlePlot.SetHandle(obj.appHandle);
                   handlePlot.SetTitle(string(handleCNF.ID_CODE_DATA(i))+'-'+string(handleCNF.STN(i,:)));
                   handlePlot.ID=handleCNF.ID_CODE_DATA(i);
                   handlePlot.STN=string(handleCNF.STN(i,:));
                   PLOTS(string(handleCNF.STN(i,:)))=PolarPlots(handlePlot);
                   pause(1);
                end
            end
            if size(PLOTS)>0
                obj.PolarPlotsMap(handleCNF.ID_CODE_SOURCE)=PLOTS;
            end
        end

        function SetDeviceID(obj,ID)
           obj.PMUdetails=DeviceDetailsHolder();
           obj.DeviceID=uint32(str2num(ID(1)));
           obj.DeviceSTN=char(ID(2));
        end
        
        function AddNewPMU(obj,PMU)
                 obj.ListPMU(PMU.ID)=PMU;
               switch PMU.CommunicationType
                    case CommunicationTypes.SpontaneousUDP
                        obj.openNewUdp(PMU);
                    case CommunicationTypes.CommandedUDP
                    case CommunicationTypes.CommandedTCP
                    case CommunicationTypes.CommandedTCPwithUDP
                end
        end

        function delete(obj)
            delete(obj.UDPconnections);
            if(size(obj.dbTemp,2)>0)
                DataBaseWrite(obj.connection,obj.dbTemp);
            end
            obj.connection.close()
            delete(obj.ListPMU);
        end

        function DeletePMU(obj,ID)
            handleConnection=[];
            for i=1:size(obj.UDPconnections)
                handle=obj.UDPconnections(i);
                for j=1:size(handle.IDs')
                    id=uint32(handle.IDs(j));
                    if id==ID
                        handleConnection=handle;
                        break;
                    end
                end
                if ~isempty(handleConnection)
                    break;
                end
            end

            remove(obj.PolarPlotsMap, ID);

            k=keys(obj.PolarPlotsMap);
            row=1;
            column=1;

            k0=keys(obj.PolarPlotsMap);
            for i=1:size(obj.PolarPlotsMap)
               key0=uint32(cell2mat(k0(i)));
               handleToSubMap=obj.PolarPlotsMap(key0);
               k1=keys(handleToSubMap);
               for j=1:size(handleToSubMap)
               key1=char(cell2mat(k1(j)));
               handleToPolarPlots=handleToSubMap(key1);
               handleToPolarPlots.HandleToPlot.Layout.Row =row;
               handleToPolarPlots.HandleToPlot.Layout.Column =column;
               column=column+1;
               if column>4
                    column=1;
                    row=row+1;
               end
               if row>4
                    break
               end
               end
            end

            if size(handleConnection.IDs)==1
                obj.UDPconnections(obj.UDPconnections== handleConnection) =[];
            else
                handleConnection.IDs(handleConnection.IDs == ID)=[];
            end
            remove(obj.ListPMU,ID);
        end
     end

end