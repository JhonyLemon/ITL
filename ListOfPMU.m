classdef ListOfPMU
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here

    properties  
    ListPMU; % map of PMU devices that we listen for
    UDPconnections;% used to handle UDP connections
    TCPconnections;% used to handle TCP connections
    QueueIn parallel.pool.DataQueue% used stop loop
    QueueOut parallel.pool.DataQueue% used to get data from loop
    cmdList;% map of commands that needs to be send currently not used
    MainAppHandle;% handle to gui
    IsRunning; % used to determine if loop is running
    Pool %Pool of threads

    end

    methods
        function obj = ListOfPMU(PMUList,MainAppHandle)
            arguments
                PMUList PMU
                MainAppHandle ProjektSynchrofazory
            end
            obj.MainAppHandle=MainAppHandle;

            obj.cmdList=containers.Map("KeyType",'uint32','ValueType','any');
            obj.ListPMU = containers.Map("KeyType",'uint32','ValueType','any');
            obj.UDPconnections = containers.Map("KeyType",'uint32','ValueType','any');
            

            for id=1:size(PMUList)
                handle=PMUList(id);
                switch handle.CommunicationType
                    case CommunicationTypes.SpontaneousUDP
                        obj.openNewUdp(handle);
                    case CommunicationTypes.CommandedUDP
                        
                    case CommunicationTypes.CommandedTCP
                        
                    case CommunicationTypes.CommandedTCPwithUDP
                        
                    otherwise
                        continue
                end
                obj.ListPMU(uint32(handle.ID))=handle;
            end

            obj.Pool = parpool('local', 2);
            obj.QueueOut=parallel.pool.DataQueue;
            obj.QueueIn=parallel.pool.DataQueue;
            afterEach(app.QueueOut,@(data) DataQueueListener(app,data));

        end

        function obj=openNewUdp(obj,PMU)
            con= udpport("datagram","Ipv4","LocalPort",PMU.LocalPort,"LocalHost",PMU.LocalHost,"OutputDatagramSize",65507,"EnablePortSharing",true);
            obj.UDPconnections(uint32(PMU.ID))=con;
        end

        function AddNewPMU(obj,PMU)
                 obj.ListPMU(PMU.ID)=PMU;
               switch handle.CommunicationType
                    case CommunicationTypes.SpontaneousUDP
                        obj.openNewUdp(PMU);
                    case CommunicationTypes.CommandedUDP
                    case CommunicationTypes.CommandedTCP
                    case CommunicationTypes.CommandedTCPwithUDP
                end
        end

        function obj=openNewTcp(obj,PMU)
            
        end

        function obj=StartListeningForData(obj)
            parfeval(obj.Pool,@ListenForData,0,obj.UDPconnections,obj.ListPMU,obj.QueueOut,obj.QueueIn);
        end

        function DataChanged(obj,id) 
            obj.QueueOut.send(obj.ListPMU(id));
        end

        function DataQueueListener(obj,data)
            obj.ListPMU(data.ID)=data;
            obj.MainAppHandle.NewData();
        end

        function obj=SendStop(obj)
            obj.QueueIn.Send("STOP");
            obj.QueueIn=parallel.pool.DataQueue;
        end

        function obj=Refresh(obj)
            obj=obj.SendStop();
            obj.StartListeningForData();
        end

        function delete(obj)
            k = keys(obj.UDPconnections);
            for i = 1:length(obj.UDPconnections)
                delete(obj.UDPconnections(uint32(cell2mat(k(i)))));
            end
            delete(obj.ListPMU);
            delete(obj.QueueIn);
            delete(obj.QueueOut);
        end

        function DeletePMU(obj,ID)
            handle=obj.ListPMU(ID);
            switch handle.CommunicationType
                case CommunicationTypes.SpontaneousUDP
                    delete(obj.UDPconnections(ID));
                case CommunicationTypes.CommandedUDP
                        
                case CommunicationTypes.CommandedTCP
                        
                case CommunicationTypes.CommandedTCPwithUDP
                        
            end
            delete(obj.ListPMU(ID));
        end
    end
    methods(Access = private,Static)
        function ListenForData(UDPconnections,ListPMU,QueueOut,QueueIn) 
            k=keys(UDPconnections);
            while true
                if QueueIn.QueueLength>0
                    break;
                end
                for i=1:size(UDPconnections)
                    key=uint32(cell2mat(k(i)));

%                     if obj.cmdList.isKey(key) && obj.ListPMU.isKey(key) && ~isempty(obj.ListPMU(key).sourceIP) && ~isempty(obj.ListPMU(key).sourcePort)
%                         cmd=obj.cmdList(key);
%                         for j=1:size(obj.cmdList(key))
%                             write(obj.UDPconnections(key),uint8(cmd(j).ToData()),"uint8",obj.ListPMU(key).sourceIP,obj.ListPMU(key).sourcePort);
%                         end
%                         obj.cmdList.remove(key);
%                     end

                    if UDPconnections(key).DatagramsAvailableFcnCount>0%if there is data to read on socket
                        frame=read(UDPconnections(key),1,"uint8");%read data from socket
                
                        ID=uint32(swapbytes(typecast(uint8(frame.Data(5:6)),'uint16')));%check ID of recived frame
                        if ListPMU.isKey(ID)%if ID from frame is in map
                            ListPMU(ID)=ListPMU(ID).InsertFrame(frame);%parse frame
                            if ListPMU(ID).isChanged==true%if frame has new data inside
                                PMU=ListPMU(ID);
                                PMU.isChanged=false;%set isChange flag to false
                                ListPMU(ID)=PMU;
                                QueueOut.Send(ListPMU(ID));% Inform about new data
                            end
                        end
                    end
                end
            end

        end
    end
end