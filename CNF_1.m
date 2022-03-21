classdef CNF_1
    %CNF_1 Summary of this class goes here
    %   Detailed explanation goes here

    properties(Access=public)
                                    %Frame synchronization word.
                                    %Leading byte: AA hex
                                    % Second byte: Frame type and version, divided as follows:
                                    % Bit 7: Reserved for future definition, must be 0 for this standard version.
           SYNCFRAMETYPE uint8;     % Bits 6–4: 000: Data Frame
                                    % 001: Header Frame
                                    % 010: Configuration Frame 1
                                    % 011: Configuration Frame 2
                                    % 101: Configuration Frame 3
                                    % 100: Command Frame (received message)
           SYNCVERSION uint8;       % Bits 3–0: Version number, in binary (1–15)
                                    % Version 1 (0001) for messages defined in IEEE Std C37.118-2005 [B6].
                                    % Version 2 (0010) for messages added in this revision,
                                    % IEEE Std C37.118.2-2011.
        
           FRAMESIZE uint16;        %Total number of bytes in the frame, including CHK.
                                    %16-bit unsigned number. Range = maximum 65535
        
           ID_CODE_SOURCE uint16;   %Data stream ID number, 16-bit integer, assigned by user, 1–65534 (0 and 65535 are
                                    % reserved). Identifies destination data stream for commands and source data stream
                                    % for other messages. A stream will be hosted by a device that can be physical or
                                    % virtual. If a device only hosts one data stream, the IDCODE identifies the device as
                                    % well as the stream. If the device hosts more than one data stream, there shall be a
                                    % different IDCODE for each stream.
        
           SOC datetime;            %Time stamp, 32-bit unsigned number, SOC count starting at midnight 01-Jan-1970
                                    % (UNIX time base).
                                    % Range is 136 years, rolls over 2106 AD.
                                    % Leap seconds are not included in count, so each year has the same number of
                                    % seconds except leap years, which have an extra day (86 400 s)
        
                                    %Fraction of second and Time Quality, time of measurement for data frames or time
                                    %of frame transmission for non-data frames.
            MTQ uint8;              % Bits 31–24: Message Time Quality as defined in 6.2.2.
            FRACSEC uint32;         % Bits 23–00: FRACSEC, 24-bit integer number. When divided by TIME_BASE
                                    % yields the actual fractional second. FRACSEC used in all messages to and from a
                                    % given PMU shall use the same TIME_BASE that is provided in the configuration
                                    % message from that PMU.
        
            CHK uint16;             %CRC-CCITT, 16-bit unsigned integer
                                    %Resolution of the fractional second time stamp (FRACSEC) in all frames.
            TIME_BASE_FLAGS uint8;  %Bits 31–24: Reserved for flags (high 8 bits).
            TIME_BASE uint32;       %Bits 23–0: 24-bit unsigned integer, which is the subdivision of the second that the
                                    %FRACSEC is based on.
                                    %The actual "fractional second of the data frame” = FRACSEC / TIME_BASE.

            NUM_PMU uint16;         %The number of PMUs included in the data frame. No limit specified. The actual limit
                                    %will be determined by the limit of 65 535 bytes in one frame ("FRAMESIZE” field)

            STN char;               %Station Name―16 bytes in ASCII format

            ID_CODE_DATA int16;     %Data stream ID number, 16-bit integer, defined in 6.2. It identifies the data stream in
                                    % field 3 and the data source in fields 9 and higher. Field 3 identifies the stream that is
                                    % being received. The IDCODEs in field 9 (and higher if more than one PMU data is
                                    % present) identify the original source of the data and will usually be associated with a
                                    % particular PMU. The IDCODEs in a data stream received directly from a PMU will
                                    % usually be the same.

                                    %Data format in data frames, 16-bit flag.
                                    % Bits 15–4: Unused
            FORMAT_FREQ uint8;      % Bit 3: 0 = FREQ/DFREQ 16-bit integer, 1 = floating point
            FORMAT_ANALOG uint8;    % Bit 2: 0 = analogs 16-bit integer, 1 = floating point
            FORMAT_PHASORS uint8;   % Bit 1: 0 = phasors 16-bit integer, 1 = floating point
            FORMAT_FORM uint8;      % Bit 0: 0 = phasor real and imaginary (rectangular), 1 = magnitude and angle (polar)
           
            PHNMR uint16;           %Number of phasors―2-byte integer.

            ANNMR uint16;           %Number of analog values―2-byte integer.

            DGNMR uint16;           %Number of digital status words―2-byte integer. Digital status words are normally 16-bit
                                    %Boolean numbers with each bit representing a digital status channel measured by a
                                    %PMU. A digital status word may be used in other user-designated ways.

            CHNAM_PHNMR string;     %Phasor and channel names―16 bytes for each phasor, analog and digital status word in
            CHNAM_ANNMR string;     %ASCII format in the same order as they are transmitted.  
            CHNAM_DGNMR string;

            PHUNIT_TYPE uint8;      %Conversion factor for phasor channels. Four bytes for each phasor.
            PHUNIT int32;           % Most significant byte: 0―voltage; 1―current.
                                    % Least significant bytes: An unsigned 24-bit word in 10–5 V or amperes per bit to scale
                                    % 16-bit integer data (if transmitted data is in floating-point format, this 24-bit value shall
                                    % be ignored).

            ANUNIT_TYPE uint8;      %Conversion factor for analog channels. Four bytes for each analog value.
            ANUNIT int32;           % Most significant byte: 0―single point-on-wave, 1―rms of analog input,
                                    % 2―peak of analog input, 5–64―reserved for future definition; 65–255―user definable.
                                    % Least significant bytes: A signed 24-bit word, user defined scaling.

            DIGUNIT0 uint16;        %Mask words for digital status words. Two 16-bit words are provided for each digital
            DIGUNIT1 uint16;        % word. The first will be used to indicate the normal status of the digital inputs by
                                    % returning a 0 when exclusive ORed (XOR) with the status word. The second will
                                    % indicate the current valid inputs to the PMU by having a bit set in the binary position
                                    % corresponding to the digital input and all other bits set to 0. See NOTE.
            
                        
            FNOM uint8;             %Nominal line frequency code (16 bit unsigned integer)
                                    % Bits 15–1:Reserved
                                    % Bit 0: 1―Fundamental frequency = 50 Hz
                                    % 0―Fundamental frequency = 60 Hz

            CFGCNT uint16;          %Configuration change count is incremented each time a change is made in the PMU
                                    % configuration. 0 is the factory default and the initial value. This count identifies the
                                    % number of changes in the configuration of this message stream. The count will be the
                                    % same in all configuration messages (CFG-1, CFG-2, and CFG-3) for the same message
                                    % revision

            DATA_RATE int16;        %Rate of phasor data transmissions―2-byte integer word (–32 767 to +32 767)
                                    % If DATA_RATE > 0, rate is number of frames per second.
                                    % If DATA_RATE < 0, rate is negative of seconds per frame.
                                    % E.g., DATA_RATE = 15 is 15 frames per second; DATA_RATE = –5 is 1 frame per
                                    % 5 s.
            
    end

    methods
        function obj = CNF_1(frame)
            obj.SYNCFRAMETYPE=uint8(bin2dec(sprintf('%d',bitget(frame.Data(2),[7 6 5],"uint8"))));%SYNC TYPE field
            obj.SYNCVERSION=uint8(bin2dec(sprintf('%d',bitget(frame.Data(2),[4 3 2 1],"uint8"))));
            obj.FRAMESIZE=swapbytes(typecast(uint8(frame.Data(3:4)),'uint16'));%FRAMESIZE field
            obj.ID_CODE_SOURCE=swapbytes(typecast(uint8(frame.Data(5:6)),'uint16'));%IDCODE field
            obj.SOC=datetime( swapbytes(typecast(uint8(frame.Data(7:10)),'uint32')), 'ConvertFrom', 'posixtime');%SOC field
            obj.MTQ=uint8(frame.Data(11));%FRASEC field Bits 31–24 
            obj.FRACSEC=swapbytes(typecast(uint8([0,frame.Data(12:14)]),'uint32'));%FRASEC field Bits 23–00
            obj.TIME_BASE=swapbytes(typecast(uint8([0 frame.Data(16:18)]),'uint32'));
            obj.TIME_BASE_FLAGS=swapbytes(typecast(uint8(frame.Data(15)),'uint8'));
            obj.NUM_PMU=swapbytes(typecast(uint8(frame.Data(19:20)),'uint16'));
            j=21;
            for i=1:obj.NUM_PMU
                obj.STN(i,1:16)=char(uint8(frame.Data(j:j+15)));
                obj.ID_CODE_DATA(i,1:1)=swapbytes(typecast(uint8(frame.Data(j+16:j+17)),'uint16'));
                obj.FORMAT_FREQ(i,1:1)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j+19),4,"uint8"))));%SYNC TYPE field
                obj.FORMAT_ANALOG(i,1:1)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j+19),3,"uint8"))));%SYNC TYPE field 
                obj.FORMAT_PHASORS(i,1:1)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j+19),2,"uint8"))));%SYNC TYPE field 
                obj.FORMAT_FORM(i,1:1)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j+19),1,"uint8"))));%SYNC TYPE field 
                obj.PHNMR(i,1:1)=swapbytes(typecast(uint8(frame.Data(j+20:j+21)),'uint16'));
                obj.ANNMR(i,1:1)=swapbytes(typecast(uint8(frame.Data(j+22:j+23)),'uint16'));
                obj.DGNMR(i,1:1)=swapbytes(typecast(uint8(frame.Data(j+24:j+25)),'uint16'));

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
                    if(obj.ANUNIT_TYPE==1)
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
            obj.CHK=swapbytes(typecast(uint8(frame.Data(j+2:j+3)),'uint16'));
        end
    end
end