connection = udpport("datagram","Ipv4","LocalPort",4713,"LocalHost",["192.168.22.103"],"OutputDatagramSize",65507,"EnablePortSharing",true);
counter=0;
PMU = PMU();
while true
    if connection.DatagramsAvailableFcnCount>0
        frame=read(connection,1,"uint8");
        if crc_16_CCITT_8bit(frame.Data(1:end-2))==swapbytes(typecast(uint8(frame.Data(end-1:end)),'uint16'))
            PMU=PMU.InsertFrame(frame);
            if ~isempty(PMU.data)
                disp("Magnitude: "+PMU.data.PHASORS0(1)+" Angle: "+rad2deg(PMU.data.PHASORS1(1)));
                   [u,v] = pol2cart(PMU.data.PHASORS1(1),PMU.data.PHASORS0(1));
                   %disp("Magnitude: "+u+" Angle: "+v);
                   compass(u,v)
                   drawnow;
            end
        end
    end
end
delete(connection);

% counter=0;
% 
% connection = udpport("datagram","Ipv4","LocalPort",4713,"LocalHost",["192.168.22.103"],"OutputDatagramSize",65507,"EnablePortSharing",true);
% while true
%     if connection.DatagramsAvailableFcnCount>0
%         frame=read(connection,1,"uint8");
%         if crc_16_CCITT_8bit(frame.Data(1:end-2))==swapbytes(typecast(uint8(frame.Data(end-1:end)),'uint16'))
%             mag=swapbytes(typecast(uint8(frame.Data(17:20)),'single'));
%             ang=swapbytes(typecast(uint8(frame.Data(21:24)),'single'));
%                 disp("Magnitude: "+mag+" Angle: "+rad2deg(ang));
% %                    [u,v] = pol2cart(ang,mag);
% %                    %disp("Magnitude: "+u+" Angle: "+v);
% %                    compass(u,v)
% %                    drawnow;
%         end
%     end
% end
% delete(connection);



