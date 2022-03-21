function UDPconnection(DataQueueRecv,DataQueueSend,IpList,Port)

    connection = udpport("datagram","Ipv4","LocalPort",Port,"LocalHost",IpList,"OutputDatagramSize",96,"EnablePortSharing",true);
        while true
            if queueIn.QueueLength>0
                break;
                elseif connection.DatagramsAvailableFcnCount>0
                    send(queueOut,read(connection,1,"uint8"));
            end
        end
    delete(connection);

end