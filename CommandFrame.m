classdef CommandFrame < Frame

    properties(Access=public)
            CMD CommandType;        %Command being sent to the PMU/PDC (0).
            EXTFRAME uint16;        %0–65518 Extended frame data, 16-bit words, 0 to 65518 bytes as indicated by frame size, data user defined.
    end
    methods
        function obj = CommandFrame(CMD,ID_CODE_SOURCE,NameValueArgs)
            arguments
                CMD CommandType
                ID_CODE_SOURCE uint16
                NameValueArgs.EXTFRAME uint16
            end
            obj.CMD=CMD;
            obj.SYNCFRAMETYPE=FrameType.CommandFrame;
            obj.SYNCVERSION=FrameVersion.Version1;
            obj.FRAMESIZE=18;
            obj.FRACSEC=0;
            obj.SOC=datetime("now");
            obj.MTQ_L_S_INDICATOR=0;
            obj.MTQ_L_S_DIRECTION=0;
            obj.MTQ_L_S_OCCURRED =0;
            obj.MTQ_L_S_PENDING=0;
            obj.ID_CODE_SOURCE=ID_CODE_SOURCE;
            if isfield(NameValueArgs,'EXTFRAME')
                obj.EXTFRAME=NameValueArgs.EXTFRAME;
                obj.FRAMESIZE=+2*size(obj.EXTFRAME);
            end
        end

        function vector=ToData(obj)
          vector=uint8([ ...
                        (0xAA) ...
                        (bitor(obj.SYNCVERSION,bitshift(obj.SYNCFRAMETYPE,4))) ...
                        flip(swapbytes(typecast(obj.FRAMESIZE,'uint8'))) ...
                        flip(swapbytes(typecast(obj.ID_CODE_SOURCE,'uint8'))) ...
                        flip(swapbytes(typecast(uint32(posixtime(datetime(obj.SOC))),'uint8'))) ...
                        flip(swapbytes(typecast(bitor(obj.FRACSEC,bitshift((bin2dec(sprintf('%d',[0 uint8(obj.MTQ_L_S_DIRECTION) uint8(obj.MTQ_L_S_OCCURRED) uint8(obj.MTQ_L_S_PENDING) bitget(obj.MTQ_L_S_INDICATOR,[4 3 2 1],"uint8")]))),24),"uint32"),'uint8'))) ...
                        flip(swapbytes(typecast(uint16(obj.CMD),'uint8'))) ...
                        flip(swapbytes(typecast(obj.EXTFRAME,'uint8'))) ...
                       ]);
          chk=crc_16_CCITT_8bit(vector);
          vector = uint8([vector flip(swapbytes(typecast(chk,'uint8')))]) ; 
        end

        
    end
end