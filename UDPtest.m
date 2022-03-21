connection = udpport("datagram","Ipv4","LocalPort",4713,"LocalHost",["192.168.22.103"],"OutputDatagramSize",65507,"EnablePortSharing",true);
while true
    if connection.DatagramsAvailableFcnCount>0
        PMU = PMU();
        PMU.InsertFrame(read(connection,1,"uint8"));
    end
end
delete(connection);
