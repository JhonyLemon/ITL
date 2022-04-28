% connection = udpport("datagram","Ipv4","LocalPort",4713,"LocalHost",["192.168.22.103"],"OutputDatagramSize",65507,"EnablePortSharing",true);
% counter=0;
% PMU = PMU();
% while true
%     if connection.DatagramsAvailableFcnCount>0
%         frame=read(connection,1,"uint8");
%         if crc_16_CCITT_8bit(frame.Data(1:end-2))==swapbytes(typecast(uint8(frame.Data(end-1:end)),'uint16'))
%             PMU=PMU.InsertFrame(frame);
%             if ~isempty(PMU.data)
%                 counter=counter+1;
%                 if counter==60
%                 disp("Magnitude: "+PMU.data.PHASORS0+" Angle: "+rad2deg(PMU.data.PHASORS1));
%                    [u,v] = pol2cart(PMU.data.PHASORS1,PMU.data.PHASORS0);
%                    %disp("Magnitude: "+u+" Angle: "+v);
%                    compass(u,v)
%                    drawnow;
%                    counter=0;
%                 end
%             end
%         end
%     end
% end
% delete(connection);
clear all;

addpath("enums\");
addpath("enums\command\");
addpath("enums\frame\");
addpath("enums\config\");
addpath("enums\data\");

DataQueueRecv=parallel.pool.DataQueue;
DataQueueSend=parallel.pool.DataQueue;
DataQueueRecv.afterEach(@(data) DataQueueListener(data));

%cmd=CommandFrame(CommandType.SendCFG_3,42);

%DataQueueSend.send(cmd);


list=ListOfPMU("PMUList",PMU("192.168.22.103",4713,42,"CommunicationType","SpontaneousUDP"),"QueueIn",DataQueueSend,"QueueOut",DataQueueRecv);

list=list.ListenForData();

list.delete();

function DataQueueListener(data)
    persistent n
        if isempty(n)
        n = 0;
        end
    if n>=30
        [u,v] = pol2cart(data.data.PHASORS1,data.data.PHASORS0);
        compass(u,v)
        drawnow;
        n=0;
    end
    n=n+1;
end



