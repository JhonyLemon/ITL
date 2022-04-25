classdef ListOfPMU
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here

    properties  
    ListPMU; 
    UDPconnections;
    TCPconnections;
    QueueIn parallel.pool.DataQueue
    QueueOut parallel.pool.DataQueue
    cmdList;

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
            obj.QueueIn.afterEach(@(data) QueueRecv(obj,data));

            obj.cmdList=containers.Map("KeyType",'uint32','ValueType','any');
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
            if ~obj.ListPMU.isKey(uint32(Id))
                obj.ListPMU(uint32(Id))=PMU(Ip,Port,Id);
            end
        end

        function obj=openNewTcp(obj,Ip,Port,Id)
            
        end

        function obj=ListenForData(obj) 
            k=keys(obj.UDPconnections);
            while true
                for i=1:size(obj.UDPconnections)
                    key=uint32(cell2mat(k(i)));
                    if obj.cmdList.isKey(key) && obj.ListPMU.isKey(key) && ~isempty(obj.ListPMU(key).sourceIP) && ~isempty(obj.ListPMU(key).sourcePort)
                        cmd=obj.cmdList(key);
                        for j=1:size(obj.cmdList(key))
                            write(obj.UDPconnections(key),uint8(cmd(j).ToData()),"uint8",obj.ListPMU(key).sourceIP,obj.ListPMU(key).sourcePort);
                            %disp("ip "+obj.UDPconnections(key).LocalHost+" port "+obj.UDPconnections(key).LocalPort);
                        end
                        obj.cmdList.remove(key);
                    end
                    if obj.UDPconnections(key).DatagramsAvailableFcnCount>0
                        frame=read(obj.UDPconnections(key),1,"uint8");
                        
                        ID=uint32(swapbytes(typecast(uint8(frame.Data(5:6)),'uint16')));
                        if obj.ListPMU.isKey(ID)
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

        end

        function obj=DataChanged(obj,id) 
            obj.QueueOut.send(obj.ListPMU(id));
        end

        function delete(obj)
            k = keys(obj.UDPconnections);
            for i = 1:length(obj.UDPconnections)
                delete(obj.UDPconnections(uint32(cell2mat(k(i)))));
            end
            delete(obj.QueueIn);
            delete(obj.QueueOut);
        end

        function obj=QueueRecv(obj,data)
            if obj.cmdList.isKey(uint32(data.ID_CODE_SOURCE))
                cmd=obj.cmdList(uint32(data.ID_CODE_SOURCE));
                obj.cmdList(uint32(data.ID_CODE_SOURCE))=[cmd data];
            else
                obj.cmdList(uint32(data.ID_CODE_SOURCE))=data;
            end

        end


    end
end