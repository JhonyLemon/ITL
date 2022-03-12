% 
% 
% u1 = udpport("LocalPort",2000,"EnablePortSharing",true,"Timeout",120,"LocalHost","127.0.0.1");
% 
% 
% while true
% data=read(u1,1024,'char');
% disp(data);
% end


%echoudp("off",3030);
% u = udpport("datagram","OutputDatagramSize",5,"LocalPort",3030);
% while true
% write(u,1:20,"uint8","127.0.0.1",3030);
% u.NumDatagramsAvailable;
% data = read(u,u.NumDatagramsAvailable,"uint8");
% end