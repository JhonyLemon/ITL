classdef ListOfPMU
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here

    properties  
    ListPMU; 
    UDPconnections;
    TCPconnections;
    QueueIn parallel.pool.DataQueue
    QueueOut parallel.pool.DataQueue
    end

    methods
        function obj = ListOfPMU(NameValueArgs)
            arguments
                NameValueArgs.QueueIn parallel.pool.DataQueue
                NameValueArgs.QueueOut parallel.pool.DataQueue
                NameValueArgs.IdList uint16
                NameValueArgs.PMUList PMU
                NameValueArgs.PortList uint16
                NameValueArgs.IpList string
                NameValueArgs.Type string
            end
            obj.QueueIn=NameValueArgs.QueueIn;
            obj.QueueOut=NameValueArgs.QueueOut;
            obj.ListPMU = containers.Map("KeyType",'uint32','ValueType','any');
            obj.UDPconnections = containers.Map("KeyType",'uint32','ValueType','any');
            obj.UDPconnections = containers.Map("KeyType",'uint32','ValueType','any');
            
            for id=1:size(NameValueArgs.IdList)
                obj.ListPMU(uint32(NameValueArgs.IdList(id)))=NameValueArgs.PMUList(id);
                if NameValueArgs.Type(id)=="UDP"
                    obj.openNewUdp(NameValueArgs.IpList(id),NameValueArgs.PortList(id),NameValueArgs.IdList(id));
                elseif NameValueArgs.Type(id)=="TCP"
                    obj.openNewTcp(NameValueArgs.IpList(id),NameValueArgs.PortList(id),NameValueArgs.IdList(id));
                end
            end

        end

        function obj=openNewUdp(obj,Ip,Port,Id)
            con= udpport("datagram","Ipv4","LocalPort",Port,"LocalHost",Ip,"OutputDatagramSize",65507,"EnablePortSharing",true);
            obj.UDPconnections(uint32(Id))=con;
            obj.ListPMU(uint32(Id))=PMU();
        end

        function obj=openNewTcp(obj,Ip,Port,Id)
            
        end

        function obj=ListenForData(obj) 
            k=keys(obj.UDPconnections);
            while true
                for i=1:size(obj.UDPconnections)
                    if obj.UDPconnections(uint32(cell2mat(k(i)))).DatagramsAvailableFcnCount>0
                        frame=read(obj.UDPconnections(uint32(cell2mat(k(i)))),1,"uint8");
                        ID=uint32(swapbytes(typecast(uint8(frame.Data(5:6)),'uint16')));
                        obj.ListPMU(ID)=obj.ListPMU(ID).InsertFrame(frame);
                        if obj.ListPMU(ID).isChanged==true
                            pum=obj.ListPMU(ID);
                            pum.isChanged=false;    
                            obj.ListPMU(ID)=pum;
                            obj.DataChanged(ID);
                        end
                    end
                end
            end

        end

        function obj=DataChanged(obj,id) 
            obj.QueueOut.send(obj.ListPMU(id));
        end

        function delete(obj)
            k = keys(obj.UDPconnections);
            for i = 1:length(obj.UDPconnections)
                delete(obj.UDPconnections(uint32(cell2mat(k(i)))));
            end
        end
    end
end