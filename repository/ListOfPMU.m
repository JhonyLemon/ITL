classdef ListOfPMU < handle
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here

    properties(Access=public)
    appHandle ProjektSynchrofazory
    ListPMU; % map of PMU devices that we listen for
    UDPconnections% used to handle UDP connections
    PMUdetails
    DeviceID
    DeviceSTN
    PolarPlotsMap
    dbFile
    connection sqlite
    dbTemp
    pathToDatabase
    end

    methods
        function obj = ListOfPMU(app)
            obj.appHandle=app;
            obj.PolarPlotsMap = containers.Map("KeyType",'uint32','ValueType','any');
            obj.ListPMU = containers.Map("KeyType",'uint32','ValueType','any');
            obj.UDPconnections=ConnectionHolder.empty;
            obj.PMUdetails=DeviceDetailsHolder();                  
            obj.dbFile="bazaITL.db";

            obj.dbTemp=struct("CommonData",struct("FRAMESIZE",uint16.empty,"IDCODE",uint16.empty,"SOC",datetime.empty,"FRACSEC",uint32.empty,"SYNCFRAMETYPE",uint8.empty,"SYNCVERSION",uint8.empty), ...
                "CommonDataFrame",struct("IDCODE",uint16.empty,"SOC",datetime.empty,"STN",string.empty,"STAT_DATA_ERROR",uint8.empty,"STAT_PMU_SYNC",uint8.empty,"STAT_DATA_SORTING",uint8.empty,"STAT_PMU_TRIGGER",uint8.empty,"STAT_CNF_CHANGE",uint8.empty,"STAT_DATA_MODIFIED",uint8.empty,"STAT_PMU_TQ",uint8.empty,"STAT_UNLOCKED_TIME",uint8.empty,"STAT_TRIGGER_REASON",uint8.empty), ...
                "DataFrameSTN",struct("IDCODE",uint16.empty,"SOC",datetime.empty,"STN",string.empty,"FREQ",double.empty,"DFREQ",double.empty), ...
                "DataFramePhasorSTN",struct("IDCODE",uint16.empty,"SOC",datetime.empty,"STN",string.empty, "PHASOR_NAME",string.empty,"MAGNITUDE",double.empty,"PHASE",double.empty), ...
                "DataFrameAnalogSTN",struct("IDCODE",uint16.empty,"SOC",datetime.empty,"STN",string.empty,"ANALOG_NAME",string.empty,"ANALOG",double.empty));
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

        function openDataBase(obj)
            if ~isempty(obj.connection)
                if obj.connection.isopen==1
                    obj.connection.close();
                end
            end
             if   ~isempty(obj.pathToDatabase)
                 if isfile(obj.pathToDatabase+"\"+obj.dbFile)
                     obj.connection = sqlite(obj.pathToDatabase+"\"+obj.dbFile, "connect");
                 else
                     obj.connection = sqlite(obj.pathToDatabase+"\"+obj.dbFile, "create");
                     execute(obj.connection,["CREATE TABLE CommonData (FRAMESIZE double, IDCODE double, SOC varchar, FRACSEC double, SYNCFRAMETYPE INTEGER, SYNCVERSION INTEGER )"]);
                     execute(obj.connection,["CREATE TABLE CommonDataFrame (IDCODE double, SOC varchar, STN INTEGER, STAT_DATA_ERROR INTEGER, STAT_PMU_SYNC INTEGER, STAT_DATA_SORTING INTEGER, STAT_PMU_TRIGGER INTEGER, STAT_CNF_CHANGE INTEGER, STAT_DATA_MODIFIED INTEGER, STAT_PMU_TQ INTEGER, STAT_UNLOCKED_TIME INTEGER, STAT_TRIGGER_REASON INTEGER )"]);
                     execute(obj.connection,["CREATE TABLE DataFrameAnalogSTN (IDCODE double, SOC varchar, STN varchar(113), ANALOG_NAME varchar(103), ANALOG double )"]);
                     execute(obj.connection,["CREATE TABLE DataFramePhasorSTN (IDCODE double, SOC varchar, STN varchar(113), PHASOR_NAME varchar(103), MAGNITUDE double, PHASE double )"]);
                     execute(obj.connection,["CREATE TABLE DataFrameSTN (IDCODE double, SOC varchar, STN varchar(113), FREQ double, DFREQ double )"]);
                 end
                 obj.connection.AutoCommit = 'off';
             end
        end

        function UdpCallback(obj,src,~)
                frame=read(src,1,"uint8");%read data from socket
                ID=uint32(swapbytes(typecast(uint8(frame.Data(5:6)),'uint16')));%check ID of recived frame
                if obj.ListPMU.isKey(ID)%if ID from frame is in map
                    handle=obj.ListPMU(ID);
                    handle.InsertFrame(frame);%parse frame
                    
                    %Wpis do bazy
                    if ~isempty(handle.data)
                        if ~isempty(obj.connection)
                            if obj.connection.isopen==1
                                obj.DataWrite(handle.data);
                                if(size(obj.dbTemp.CommonData.SOC,2)>5000)
                                    DataBaseWrite(obj.connection,obj.dbTemp);
                                    obj.dbTemp=struct("CommonData",struct("FRAMESIZE",uint16.empty,"IDCODE",uint16.empty,"SOC",datetime.empty,"FRACSEC",uint32.empty,"SYNCFRAMETYPE",uint8.empty,"SYNCVERSION",uint8.empty), ...
                                        "CommonDataFrame",struct("IDCODE",uint16.empty,"SOC",datetime.empty,"STN",string.empty,"STAT_DATA_ERROR",uint8.empty,"STAT_PMU_SYNC",uint8.empty,"STAT_DATA_SORTING",uint8.empty,"STAT_PMU_TRIGGER",uint8.empty,"STAT_CNF_CHANGE",uint8.empty,"STAT_DATA_MODIFIED",uint8.empty,"STAT_PMU_TQ",uint8.empty,"STAT_UNLOCKED_TIME",uint8.empty,"STAT_TRIGGER_REASON",uint8.empty), ...
                                        "DataFrameSTN",struct("IDCODE",uint16.empty,"SOC",datetime.empty,"STN",string.empty,"FREQ",double.empty,"DFREQ",double.empty), ...
                                        "DataFramePhasorSTN",struct("IDCODE",uint16.empty,"SOC",datetime.empty,"STN",string.empty, "PHASOR_NAME",string.empty,"MAGNITUDE",double.empty,"PHASE",double.empty), ...
                                        "DataFrameAnalogSTN",struct("IDCODE",uint16.empty,"SOC",datetime.empty,"STN",string.empty,"ANALOG_NAME",string.empty,"ANALOG",double.empty));
                                end
                            end
                        end
                    end
                    
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

        function DataWrite(obj,data)

            obj.dbTemp.CommonData.FRAMESIZE(end+1)=data.FRAMESIZE;
            obj.dbTemp.CommonData.IDCODE(end+1)=data.ID_CODE_SOURCE;
            obj.dbTemp.CommonData.SOC(end+1)=data.SOC;
            obj.dbTemp.CommonData.FRACSEC(end+1)=data.FRACSEC;
            obj.dbTemp.CommonData.SYNCFRAMETYPE(end+1)=uint8(data.SYNCFRAMETYPE);
            obj.dbTemp.CommonData.SYNCVERSION(end+1)=uint8(data.SYNCVERSION);

            k=keys(data.STAT_DATA_ERROR);
            for j=1:size(data.STAT_DATA_ERROR)
                key=char(cell2mat(k(j)));

                obj.dbTemp.CommonDataFrame.IDCODE(end+1)=data.ID_CODE_SOURCE;
                obj.dbTemp.CommonDataFrame.SOC(end+1)=data.SOC;
                obj.dbTemp.CommonDataFrame.STN(end+1)=string(key);
                obj.dbTemp.CommonDataFrame.STAT_DATA_ERROR(end+1)=uint8(data.STAT_DATA_ERROR(key));
                obj.dbTemp.CommonDataFrame.STAT_PMU_SYNC(end+1)=uint8(data.STAT_PMU_SYNC(key));
                obj.dbTemp.CommonDataFrame.STAT_DATA_SORTING(end+1)=uint8(data.STAT_DATA_SORTING(key));
                obj.dbTemp.CommonDataFrame.STAT_PMU_TRIGGER(end+1)=uint8(data.STAT_PMU_TRIGGER(key));
                obj.dbTemp.CommonDataFrame.STAT_CNF_CHANGE(end+1)=uint8(data.STAT_CNF_CHANGE(key));
                obj.dbTemp.CommonDataFrame.STAT_DATA_MODIFIED(end+1)=uint8(data.STAT_DATA_MODIFIED(key));
                obj.dbTemp.CommonDataFrame.STAT_PMU_TQ(end+1)=uint8(data.STAT_PMU_TQ(key));
                obj.dbTemp.CommonDataFrame.STAT_UNLOCKED_TIME(end+1)=uint8(data.STAT_UNLOCKED_TIME(key));
                obj.dbTemp.CommonDataFrame.STAT_TRIGGER_REASON(end+1)=uint8(data.STAT_TRIGGER_REASON(key));

                obj.dbTemp.DataFrameSTN.IDCODE(end+1)=data.ID_CODE_SOURCE;
                obj.dbTemp.DataFrameSTN.SOC(end+1)=data.SOC;
                obj.dbTemp.DataFrameSTN.STN(end+1)=string(key);
                obj.dbTemp.DataFrameSTN.FREQ(end+1)=data.FREQ(key);
                obj.dbTemp.DataFrameSTN.DFREQ(end+1)=data.DFREQ(key);

                phasor00=data.PHASORS0(key);
                phasor10=data.PHASORS1(key);
                k1=keys(phasor00);
                for m=1:size(phasor00)
                    key1=char(cell2mat(k1(m)));
                    phasor0=phasor00(key1);
                    phasor1=phasor10(key1);

                    obj.dbTemp.DataFramePhasorSTN.IDCODE(end+1)=data.ID_CODE_SOURCE;
                    obj.dbTemp.DataFramePhasorSTN.SOC(end+1)=data.SOC;
                    obj.dbTemp.DataFramePhasorSTN.STN(end+1)=string(key);
                    obj.dbTemp.DataFramePhasorSTN.PHASOR_NAME(end+1)=string(key1);
                    obj.dbTemp.DataFramePhasorSTN.MAGNITUDE(end+1)=phasor0;
                    obj.dbTemp.DataFramePhasorSTN.PHASE(end+1)=phasor1;

                end

                analog=data.ANALOG(key);
                k1=keys(analog);
                for m=1:size(analog)
                    key1=char(cell2mat(k1(m)));
                    analog0=analog(key1);
                    %Writring dataframe analog fields

                    obj.dbTemp.DataFrameAnalogSTN.IDCODE(end+1)=data.ID_CODE_SOURCE;
                    obj.dbTemp.DataFrameAnalogSTN.SOC(end+1)=data.SOC;
                    obj.dbTemp.DataFrameAnalogSTN.STN(end+1)=string(key);
                    obj.dbTemp.DataFrameAnalogSTN.ANALOG_NAME(end+1)=string(key1);
                    obj.dbTemp.DataFrameAnalogSTN.ANALOG(end+1)=analog0;

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
            if ~isempty(obj.connection)
                if obj.connection.isopen==1
                    if(size(obj.dbTemp.CommonData.SOC,2)>0)
                        DataBaseWrite(obj.connection,obj.dbTemp);
                    end
                end
            end
            if ~isempty(obj.connection)
                if obj.connection.isopen==1
                    obj.connection.close();
                end
            end
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