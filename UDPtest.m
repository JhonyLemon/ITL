load("data.mat","data");
%load("parseddata.mat","ParsedData");
format hex
% 
% ParsedData=struct('SYNC',swapbytes(typecast(uint8(data.Data(1:2)),'uint16')),...
%                   'FRAMESIZE',swapbytes(typecast(uint8(data.Data(3:4)),'uint16')),...
%                   'IDCODE',swapbytes(typecast(uint8(data.Data(5:6)),'uint16')),...
%                   'SOC',datetime( swapbytes(typecast(uint8(data.Data(7:10)),'uint32')), 'ConvertFrom', 'posixtime','TimeZone','Europe/Warsaw' ),...
%                   'FRACSEC',data.Data(11:14),...
%                   'STAT',data.Data(15:16));

[~,col] = size(data.Data);
            ParsedData=struct('SYNC',swapbytes(typecast(uint8(data.Data(1:2)),'uint16')),...
                  'FRAMESIZE',swapbytes(typecast(uint8(data.Data(3:4)),'uint16')),...
                  'IDCODESOURCE',swapbytes(typecast(uint8(data.Data(5:6)),'uint16')),...
                  'SOC',datetime( swapbytes(typecast(uint8(data.Data(7:10)),'uint32')), 'ConvertFrom', 'posixtime','TimeZone','Europe/Warsaw' ),...
                  'FRACSEC',data.Data(11:14),...
                  'TIMEBASE',swapbytes(typecast(uint8(data.Data(15:18)),'uint32')),...
                  'NUM_PMU',swapbytes(typecast(uint8(data.Data(19:20)),'uint16')));
                      ParsedData.STN=zeros(ParsedData.NUM_PMU,0);
                      ParsedData.IDCODEDATA=zeros(ParsedData.NUM_PMU,0);
                      ParsedData.FORMAT=zeros(ParsedData.NUM_PMU,0);
                      ParsedData.PHNMR=zeros(ParsedData.NUM_PMU,0);
                      ParsedData.ANNMR=zeros(ParsedData.NUM_PMU,0);
                      ParsedData.DGNMR=zeros(ParsedData.NUM_PMU,0);
                      ParsedData.CHNAM=zeros(ParsedData.NUM_PMU,0);
                      ParsedData.PHUNIT=zeros(ParsedData.NUM_PMU,0);
                      ParsedData.ANUNIT=zeros(ParsedData.NUM_PMU,0);
                      ParsedData.DIGUNIT=zeros(ParsedData.NUM_PMU,0);
                      ParsedData.FNOM=zeros(ParsedData.NUM_PMU,0);
                      ParsedData.CFGCNT=zeros(ParsedData.NUM_PMU,0);
                      j=21;
                  for i=1:ParsedData.NUM_PMU
                      ParsedData.STN(i,1:16)=data.Data(j:(j+15));
                      ParsedData.IDCODEDATA(i,1:2)=data.Data(j+16:j+17);
                      ParsedData.FORMAT(i,1:2)=data.Data(j+18:j+19);
                      ParsedData.PHNMR(i,1:1)=swapbytes(typecast(uint8(data.Data(j+20:j+21)),'uint16'));
                      ParsedData.ANNMR(i,1:1)=swapbytes(typecast(uint8(data.Data(j+22:j+23)),'uint16'));
                      ParsedData.DGNMR(i,1:1)=swapbytes(typecast(uint8(data.Data(j+24:j+25)),'uint16'));
                      k=(16*(ParsedData.PHNMR(i)+ParsedData.ANNMR(i)+16*ParsedData.DGNMR(i)));
                      ParsedData.CHNAM(i,1:k)=data.Data(j+26:j+25+k);
                      j=j+26+k;
                      k=4*ParsedData.PHNMR(i);
                      ParsedData.PHUNIT(i,1:k)=data.Data(j:j+k-1);
                      j=j+k;
                      k=4*ParsedData.ANNMR(i);
                      ParsedData.ANUNIT(i,1:k)=data.Data(j:j+k-1);
                      j=j+k;
                      k=4*ParsedData.DGNMR(i);
                      ParsedData.DIGUNIT(i,1:k)=data.Data(j:j+k-1);
                      j=j+k;
                      ParsedData.FNOM(i,1:2)=data.Data(j:j+1);
                      ParsedData.CFGCNT(i,1:2)=data.Data(j+2:j+3);
                      j=j+4;
                  end
                  ParsedData.DATA_RATE=swapbytes(typecast(uint8(data.Data(col-3:col-2)),'uint16'));
                  ParsedData.CHK=swapbytes(typecast(uint8(data.Data(col:col-1)),'uint16'));