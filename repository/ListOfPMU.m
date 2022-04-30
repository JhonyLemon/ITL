classdef ListOfPMU < handle
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here

    properties  
    ListPMU; % map of PMU devices that we listen for
    UDPconnections% used to handle UDP connections
%     TCPconnections;% used to handle TCP connections
%     QueueIn parallel.pool.DataQueue% used stop loop
%     QueueOut parallel.pool.DataQueue% used to get data from loop
%     cmdList;% map of commands that needs to be send currently not used
%     IsRunning; % used to determine if loop is running
%     Pool %Pool of threads

    end

    methods
        function obj = ListOfPMU()
            obj.ListPMU = containers.Map("KeyType",'uint32','ValueType','any');
            obj.UDPconnections=[udpport("datagram","Ipv4","LocalHost","127.0.0.1",LocalPort=4713)];
        end

        function openNewUdp(obj,PMU)
                for i=1:size(obj.UDPconnections)
                    disp(true);
                    disp(~strcmp(obj.UDPconnections(i).LocalHost,PMU.LocalHost));
                    disp(obj.UDPconnections(i).LocalPort~=PMU.LocalPort);
                    if ~strcmp(obj.UDPconnections(i).LocalHost,PMU.LocalHost) || obj.UDPconnections(i).LocalPort~=PMU.LocalPort
                        con= udpport("datagram","Ipv4","LocalPort",PMU.LocalPort,"LocalHost",PMU.LocalHost,"OutputDatagramSize",65507,"EnablePortSharing",true);
                        con.configureCallback("datagram",1,@(src,evt) UdpCallback(obj,src,evt));
                        obj.UDPconnections(end+1)=con;
                        break;
                    end
                end
        end

        function UdpCallback(obj,src,~)
                frame=read(src,1,"uint8");%read data from socket
                ID=uint32(swapbytes(typecast(uint8(frame.Data(5:6)),'uint16')));%check ID of recived frame
                if obj.ListPMU.isKey(ID)%if ID from frame is in map
                    handle=obj.ListPMU(ID);
                    handle.InsertFrame(frame);%parse frame
                end
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



        function isUsed=CheckIfUsed(obj,src)
            isUsed=false;
           k=keys(obj.ListPMU);
           for i=1:size(obj.ListPMU)
                key=uint32(cell2mat(k(i)));
                if obj.ListPMU(key).LocalHost==src.LocalHost && obj.ListPMU(key).LocalPort==src.LocalPort
                    isUsed=true;
                    break;
                end
           end
           disp("IsUsed:"+isUsed);
        end
        function delete(obj)
            for i = 1:size(obj.UDPconnections)
                delete(obj.UDPconnections(i));
            end
            delete(obj.ListPMU);
        end

        function DeletePMU(obj,ID)
            isUsed=false;
            k=0;
            [rows,columns]=size(obj.UDPconnections);
            for i=1:columns
                handle=obj.ListPMU(ID);
                if strcmp(handle.LocalHost,obj.UDPconnections(1,i).LocalHost) && handle.LocalPort==obj.UDPconnections(1,i).LocalPort
                   m=i;
                   k=keys(obj.ListPMU);
                   for j=1:size(obj.ListPMU)
                        key=uint32(cell2mat(k(j)));
                        handleKey=obj.ListPMU(key);
                        if ~strcmp(handleKey.LocalHost,obj.UDPconnections(1,i).LocalHost) && handleKey.LocalPost~=obj.UDPconnections(1,i).LocalPost
                            isUsed=true;
                            break;
                        end
                   end
                end
            end
            if isUsed==false && m~=0
                delete(obj.UDPconnections(1,m));
            end
                remove(obj.ListPMU,ID);
        end
     end

end