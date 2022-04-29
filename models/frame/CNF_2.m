classdef CNF_2 < ConfigFrame
    %CNF_2 Summary of this class goes here
    %   Detailed explanation goes here
    properties(Access=public)
        
            PHUNIT_TYPE PhasorConversionFactor;      %Conversion factor for phasor channels. Four bytes for each phasor.
            PHUNIT int32;           % Most significant byte: 0―voltage; 1―current.
                                    % Least significant bytes: An unsigned 24-bit word in 10–5 V or amperes per bit to scale
                                    % 16-bit integer data (if transmitted data is in floating-point format, this 24-bit value shall
                                    % be ignored).

            ANUNIT_TYPE AnalogConversionFactor;      %Conversion factor for analog channels. Four bytes for each analog value.
            ANUNIT int32;           % Most significant byte: 0―single point-on-wave, 1―rms of analog input,
                                    % 2―peak of analog input, 5–64―reserved for future definition; 65–255―user definable.
                                    % Least significant bytes: A signed 24-bit word, user defined scaling.
    end

    methods
        function obj = CNF_2(frame)
            obj@ConfigFrame(frame);
            obj.TIME_BASE=swapbytes(typecast(uint8([0 frame.Data(16:18)]),'uint32'));
            obj.TIME_BASE_FLAGS=swapbytes(typecast(uint8(frame.Data(15)),'uint8'));
            obj.NUM_PMU=swapbytes(typecast(uint8(frame.Data(19:20)),'uint16'));
            j=21;
            for i=1:obj.NUM_PMU
                obj.STN(i,1:16)=char(uint8(frame.Data(j:j+15)));
                obj.ID_CODE_DATA(i)=swapbytes(typecast(uint8(frame.Data(j+16:j+17)),'uint16'));
                obj.FORMAT_FREQ(i)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j+19),4,"uint8"))));%SYNC TYPE field
                obj.FORMAT_ANALOG(i)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j+19),3,"uint8"))));%SYNC TYPE field 
                obj.FORMAT_PHASORS(i)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j+19),2,"uint8"))));%SYNC TYPE field 
                obj.FORMAT_FORM(i)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j+19),1,"uint8"))));%SYNC TYPE field 
                obj.PHNMR(i)=swapbytes(typecast(uint8(frame.Data(j+20:j+21)),'uint16'));
                obj.ANNMR(i)=swapbytes(typecast(uint8(frame.Data(j+22:j+23)),'uint16'));
                obj.DGNMR(i)=swapbytes(typecast(uint8(frame.Data(j+24:j+25)),'uint16'));

                j=j+26;
                for k=1:obj.PHNMR(i)
                   obj.CHNAM_PHNMR(i,k)=strtrim(string(char(uint8(frame.Data(j:j+15)))));
                   j=j+16;
                end
                for k=1:obj.ANNMR(i)
                   obj.CHNAM_ANNMR(i,k)=strtrim(string(char(uint8(frame.Data(j:j+15)))));
                   j=j+16;
                end
                for k=1:obj.DGNMR(i)
                   obj.CHNAM_DGNMR(i,k)=strtrim(string(char(uint8(frame.Data(j:j+(16*16-1))))));
                   j=j+16*16;
                end
                for k=1:obj.PHNMR(i)
                   obj.PHUNIT(i,k)=swapbytes(typecast(uint8([0 frame.Data(j+1:j+3)]),'uint32'));
                   obj.PHUNIT_TYPE(i,k)=uint8(frame.Data(j));
                   j=j+4;
                end
                for k=1:obj.ANNMR(i)
                    obj.ANUNIT_TYPE=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j+1),8,"uint8"))));
                    if obj.ANUNIT_TYPE==AnalogConversionFactor.rmsOfAnalog
                       obj.ANUNIT(i,k)=(-1*(swapbytes(typecast(uint8([0 bitxor(255,frame.Data(j+1:j+3),"uint8")]),'int32'))+1));
                    else
                        obj.ANUNIT(i,k)=swapbytes(typecast(uint8([0 frame.Data(j+1:j+3)]),'int32'));
                    end
                    j=j+4;
                end
                for k=1:obj.DGNMR(i)
                   obj.DIGUNIT0(i,k)=swapbytes(typecast(uint8(frame.Data(j:j+1)),'uint16'));
                   obj.DIGUNIT1(i,k)=swapbytes(typecast(uint8(frame.Data(j+2:j+3)),'uint16'));
                   j=j+4;
                end
                obj.FNOM(i,1)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j+1),1,"uint8"))));
                obj.CFGCNT(i,1)=swapbytes(typecast(uint8(frame.Data(j+2:j+3)),'uint16'));
                j=j+4;
            end
            obj.DATA_RATE=swapbytes(typecast(uint8(frame.Data(j:j+1)),'uint16'));
        end

    end
end