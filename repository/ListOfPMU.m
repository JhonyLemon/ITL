classdef ListOfPMU < handle
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here

    properties  
    ListPMU; % map of PMU devices that we listen for
    UDPconnections% used to handle UDP connections
    PMUdetails
    DeviceID
%     TCPconnections;% used to handle TCP connections
%     cmdList;% map of commands that needs to be send currently not used

    end

    methods
        function obj = ListOfPMU()
            obj.ListPMU = containers.Map("KeyType",'uint32','ValueType','any');
            obj.UDPconnections=ConnectionHolder.empty;
            obj.PMUdetails=DeviceDetailsHolder();
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
                    if obj.DeviceID==ID
                        if ~isempty(handle.data)
                            handleData=handle.data;
                            obj.PMUdetails.SOC(end+1)=handleData.SOC;
                            obj.PMUdetails.FREQ(end+1)=handleData.FREQ;
                            obj.PMUdetails.DFREQ(end+1)=handleData.DFREQ;
                            obj.PMUdetails.PHASORS0(end+1)=handleData.PHASORS0;
                            obj.PMUdetails.PHASORS1(end+1)=handleData.PHASORS1;
                            obj.PMUdetails.ANALOG(end+1)=handleData.ANALOG;
                        end
                    end
                end
        end

        function SetDeviceID(obj,ID)
           obj.PMUdetails=DeviceDetailsHolder();
           obj.DeviceID=ID;
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

            if size(handleConnection.IDs)==1
                obj.UDPconnections(obj.UDPconnections== handleConnection) =[];
            else
                handleConnection.IDs(handleConnection.IDs == ID)=[];
            end
            remove(obj.ListPMU,ID);
        end
     end

end