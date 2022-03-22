classdef CNF_3
    %CNF_3 Summary of this class goes here
    %   Detailed explanation goes here

    properties(Access=public)


           sha256 char              %Used to determine if new frame has different values

                                 %Frame synchronization word.
                                 %Leading byte: AA hex
                                 % Second byte: Frame type and version, divided as follows:
                                 % Bit 7: Reserved for future definition, must be 0 for this standard version.
           SYNCFRAMETYPE uint8;  % Bits 6–4: 000: Data Frame
                                 % 001: Header Frame
                                 % 010: Configuration Frame 1
                                 % 011: Configuration Frame 2
                                 % 101: Configuration Frame 3
                                 % 100: Command Frame (received message)
           SYNCVERSION uint8;    % Bits 3–0: Version number, in binary (1–15)
                                 % Version 1 (0001) for messages defined in IEEE Std C37.118-2005 [B6].
                                 % Version 2 (0010) for messages added in this revision,
                                 % IEEE Std C37.118.2-2011.
        
           FRAMESIZE uint16;     %Total number of bytes in the frame, including CHK.
                                 %16-bit unsigned number. Range = maximum 65535
        
           ID_CODE_SOURCE uint16;%Data stream ID number, 16-bit integer, assigned by user, 1–65534 (0 and 65535 are
                                 % reserved). Identifies destination data stream for commands and source data stream
                                 % for other messages. A stream will be hosted by a device that can be physical or
                                 % virtual. If a device only hosts one data stream, the IDCODE identifies the device as
                                 % well as the stream. If the device hosts more than one data stream, there shall be a
                                 % different IDCODE for each stream.
        
           SOC datetime;         %Time stamp, 32-bit unsigned number, SOC count starting at midnight 01-Jan-1970
                                 % (UNIX time base).
                                 % Range is 136 years, rolls over 2106 AD.
                                 % Leap seconds are not included in count, so each year has the same number of
                                 % seconds except leap years, which have an extra day (86 400 s)
        
                                %Fraction of second and Time Quality, time of measurement for data frames or time
                                %of frame transmission for non-data frames.
            MTQ uint8;          % Bits 31–24: Message Time Quality as defined in 6.2.2.
            FRACSEC uint32;     % Bits 23–00: FRACSEC, 24-bit integer number. When divided by TIME_BASE
                                % yields the actual fractional second. FRACSEC used in all messages to and from a
                                % given PMU shall use the same TIME_BASE that is provided in the configuration
                                % message from that PMU.
        
            CHK uint16;         %CRC-CCITT, 16-bit unsigned integer

            CONT_IDX uint16;    %Continuation index for fragmented frames:
                                % 0: only frame in configuration, no further frames
                                % 1: first frame in series, more to follow
                                % 2–65534: number of each succeeding frame, in order
                                % 65535 (hex FFFF): last frame in series

                                %Resolution of the fractional second time stamp (FRACSEC) in all frames.
        TIME_BASE_FLAGS uint8;  %Bits 31–24: Reserved for flags (high 8 bits).
        TIME_BASE uint32;       %Bits 23–0: 24-bit unsigned integer, which is the subdivision of the second that the
                                %FRACSEC is based on.
                                %The actual "fractional second of the data frame” = FRACSEC / TIME_BASE.

        NUM_PMU uint16;         %The number of PMUs included in the data frame. No limit specified. The actual limit
                                %will be determined by the limit of 65 535 bytes in one frame ("FRAMESIZE” field)

            STN char;         %1–256 Station Name―in UTF-8 format, up to 255 bytes using the name field format (see
                                %Table 11).

            ID_CODE_DATA int16; %Data stream ID number, 16-bit integer, defined in 6.2. It identifies the data stream in
                                % field 3 and the data source in fields 9 and higher. Field 3 identifies the stream that is
                                % being received. The IDCODEs in field 9 (and higher if more than one PMU data is
                                % present) identify the original source of the data and will usually be associated with a
                                % particular PMU. The IDCODEs in a data stream received directly from a PMU will
                                % usually be the same.

            G_PMU_ID uint16;    %This 128-bit Global PMU ID shall be a user-assigned value. It shall be stored in the
                                % PMU or other sending device so it can be sent with this configuration 3 message. It
                                % allows uniquely identifying PMUs in a system that has more than 65535 PMUs. The
                                % coding for the 16 bytes is left to the user for assignment.

                                %Data format in data frames, 16-bit flag.
                                % Bits 15–4: Unused
           FORMAT_FREQ uint8;   % Bit 3: 0 = FREQ/DFREQ 16-bit integer, 1 = floating point
           FORMAT_ANALOG uint8; % Bit 2: 0 = analogs 16-bit integer, 1 = floating point
           FORMAT_PHASORS uint8;% Bit 1: 0 = phasors 16-bit integer, 1 = floating point
           FORMAT_FORM uint8;   % Bit 0: 0 = phasor real and imaginary (rectangular), 1 = magnitude and angle (polar)
           
            PHNMR uint16;       %Number of phasors―2-byte integer.

            ANNMR uint16;       %Number of analog values―2-byte integer.

            DGNMR uint16;       %Number of digital status words―2-byte integer. Digital status words are normally 16-bit
                                %Boolean numbers with each bit representing a digital status channel measured by a
                                %PMU. A digital status word may be used in other user-designated ways.
            
  CHNAM_PHNMR string;           %Channel Names―one name for each phasor, analog, and digital channel in UTF-8
  CHNAM_ANNMR string;           % using the name field format (see Table 12).
   CHNAM_DGNMR string;          % Names appear in the same order as they are transmitted: all phasors followed by all
                                % analogs followed by all digitals.
                                % For digital channels, the order is the same as described for configurations 1 and 2.

                                %Magnitude and angle scaling for phasors with data flags. This factor has three 4-byte
                                % long words: the first is bit-mapped flags, the second is a magnitude scale factor, and
                                % the third is an angle offset.
                                % First 4-byte word
                                % First 2 bytes: 16-bit flag that indicates the type of data modification when data is
                                % being modified by a continuous process. When no modification process is being
                                % applied, all bits shall be set to 0.
                                % (Bit 0 is the LSB, Bit 15 is the MSB.)
                                % This flag shall be used in conjunction with the data modification bit (Bit 9) in the
                                % status word. That bit shall be set in any frame that data has been modified by any
                                % process including those indicated in this flag   
                                %Bit # Meaning when bit set
            PHSCALE_1_0 uint8;  % 0 Not used, reserved
            PHSCALE_1_1 uint8;  % 1 Up sampled with interpolation
            PHSCALE_1_2 uint8;  % 2 Upsampled with extrapolation
            PHSCALE_1_3 uint8;  % 3 Down sampled by reselection (selecting every Nth sample)
            PHSCALE_1_4 uint8;  % 4 Down sampled with FIR filter
            PHSCALE_1_5 uint8;  % 5 Down sampled with non-FIR filter
            PHSCALE_1_6 uint8;  % 6 Filtered without changing sampling
            PHSCALE_1_7 uint8;  % 7 Phasor magnitude adjusted for calibration
            PHSCALE_1_8 uint8;  % 8 Phasor phase adjusted for calibration
            PHSCALE_1_9 uint8;  % 9 Phasor phase adjusted for rotation ( ±30º, ±120º, etc.)
            PHSCALE_1_10 uint8; % 10 Pseudo-phasor value (combined from other phasors)
         PHSCALE_1_11_14 uint8; % 11–14 Reserved for future assignment
            PHSCALE_1_15 uint8; % 15 Modification applied, type not here defined
                                % Third byte: phasor type indication (Bit 0 is the LSB, Bit 7 is the MSB)
         PHSCALE_1_20_23 uint8; % Bits 07–04: Reserved for future use
         PHSCALE_1_19 uint8;    % Bit 03: 0―voltage; 1―current.
         PHSCALE_1_16_18 uint8; % Bits 02–00: Phasor component, coded as follows
                                % 111: Reserved
                                % 110: Phase C
                                % 101: Phase B
                                % 100: Phase A
                                % 011: Reserved
                                % 010: Negative sequence
                                % 001: Positive sequence
                                % 000: Zero sequence
         PHSCALE_1_24_31 uint8; % Fourth byte: available for user designation
                                % Second and third 4-byte words
                                % For phasor X = Xm e jφ, this defines the scaling Y and angle offset θ to be applied to the
                                % phasor as follows:
                                % X' = Y × Xm e j (φ–
                                % θ)
            PHSCALE_2 single;   % The second 4-byte word is the scale factor Y in 32-bit IEEE floating point. This scales
                                % phasor data to primary volts or amperes. If phasors are transmitted in floating-point
                                % format and scaled already, this value shall be set to 1.
            PHSCALE_3 single;   % The third 4-byte word is the phasor angle adjustment θ in radians represented in
                                % 32-bit IEEE floating point. If phasors are transmitted in floating-point format and
                                % scaled already, this value shall be set to 0

                                %Linear scaling for analog channels. For analog value X, this defines scale M and offset
                                % B for X' = M × X + B.
            ANSCALE_M single;   % First 4 bytes: Magnitude scaling M in 32-bit floating point.
            ANSCALE_B single;   % Last 4 bytes: Offset B in 32-bit floating point.

            DIGUNIT0 uint16;    %Mask words for digital status words. Two 16-bit words are provided for each digital
            DIGUNIT1 uint16;    % word. The first will be used to indicate the normal status of the digital inputs by
                                % returning a 0 when exclusive Ored (XOR) with the status word. The second will
                                % indicate the current valid inputs to the PMU by having a bit set in the binary position
                                % corresponding to the digital input and all other bits set to 0. See NOTE. 

            PMU_LAT single;     %PMU Latitude in degrees, range –90.0 to +90.0. Positive values are N of equator.
                                % WGS 84 datum. Number in 32-bit IEEE floating-point format. For unspecified
                                % locations, infinity shall be used.

            PMU_LON single;     %PMU Longitude in degrees, range –179.99999999 to +180. Positive values are E of
                                % the prime meridian. WGS 84 datum. Number in 32-bit IEEE floating-point format.
                                % For unspecified locations, infinity shall be used.

            PMU_ELEV single;    %PMU Elevation in meters, Positive values are above mean sea level. WGS 84 datum.
                                % Number in 32-bit IEEE floating-point format. For unspecified locations, infinity shall
                                % be used.
                                           
            SVC_CLASS char;     %Service class, as defined in IEEE Std C37.118.1, a single ASCII character. In 2011 it
                                % is M or P.

            WINDOW int32;       %Phasor measurement window length including all filters and estimation windows in
                                % effect. Value is in microseconds, 4-byte signed integer value (to nearest
                                % microsecond). (For information only, any required compensation is already applied to
                                % the measurement.)

            GRP_DLY  int32;     %Phasor measurement group delay including all filters and estimation windows in
                                % effect. Value is in microseconds, 4-byte signed integer value (to nearest
                                % microsecond). (For information only, any required compensation is already applied to
                                % the measurement.)

            FNOM uint16;        %Nominal line frequency code (16 bit unsigned integer)
                                % Bits 15–1: Reserved
                                % Bit 0: 1―Fundamental frequency = 50 Hz
                                % 0―Fundamental frequency = 60 Hz

            DATA_RATE int16;    %Rate of phasor data transmissions―2-byte integer word (–32 767 to +32 767)
                                % If DATA_RATE > 0, rate is number of frames per second.
                                % If DATA_RATE < 0, rate is negative of seconds per frame.
                                % E.g.: DATA_RATE = 15 is 15 frames per second;
                                % DATA_RATE = –5 is 1 frame per 5 s.

            CFGCNT uint16;      %Configuration change count is incremented each time a change is made in the PMU
                                % configuration. 0 is the factory default and the initial value. This count identifies the
                                % number of changes in the configuration of this message stream. The count will be the
                                % same in all configuration messages (CFG-1, CFG-2, and CFG-3) for the same message
                                % revision
    end

    methods
        function obj = CNF_3(frame)
            obj.sha256=SHA256(uint8(frame.Data));

            obj.SYNCFRAMETYPE=uint8(bin2dec(sprintf('%d',bitget(frame.Data(2),[7 6 5],"uint8"))));%SYNC TYPE field
            obj.SYNCVERSION=uint8(bin2dec(sprintf('%d',bitget(frame.Data(2),[4 3 2 1],"uint8"))));
            obj.FRAMESIZE=swapbytes(typecast(uint8(frame.Data(3:4)),'uint16'));%FRAMESIZE field
            obj.ID_CODE_SOURCE=swapbytes(typecast(uint8(frame.Data(5:6)),'uint16'));%IDCODE field
            obj.SOC=datetime( swapbytes(typecast(uint8(frame.Data(7:10)),'uint32')), 'ConvertFrom', 'posixtime');%SOC field
            obj.MTQ=uint8(frame.Data(11));%FRASEC field Bits 31–24 
            obj.FRACSEC=swapbytes(typecast(uint8([0,frame.Data(12:14)]),'uint32'));%FRASEC field Bits 23–00
            obj.CONT_IDX=swapbytes(typecast(uint8(frame.Data(15:16)),'uint16'));
            obj.TIME_BASE_FLAGS=swapbytes(typecast(uint8(frame.Data(17)),'uint8'));
            obj.TIME_BASE=swapbytes(typecast(uint8([0 frame.Data(18:19)]),'uint32'));
            obj.NUM_PMU=swapbytes(typecast(uint8(frame.Data(20:21)),'uint16'));
            j=10;
            for i=1:obj.NUM_PMU

            k=swapbytes(typecast(uint8(frame.Data(j)),'uint8'));
            obj.STN(i,1:k)=char(uint8(frame.Data(j+1:j+k-1)));%Might want to check if correct
            j=j+k+1;

            obj.ID_CODE_DATA(i)=swapbytes(typecast(uint8(frame.Data(j:j+1)),'uint16'));
            j=j+2;

            obj.G_PMU_ID(i)=char(uint8(frame.Data(j:j+15)));
            j=j+16;

            obj.FORMAT_FREQ(i,1:1)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j+1),4,"uint8"))));%SYNC TYPE field
            obj.FORMAT_ANALOG(i,1:1)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j+1),3,"uint8"))));%SYNC TYPE field 
            obj.FORMAT_PHASORS(i,1:1)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j+1),2,"uint8"))));%SYNC TYPE field 
            obj.FORMAT_FORM(i,1:1)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j+1),1,"uint8"))));%SYNC TYPE field
            j=j+2;

            obj.PHNMR(i,1:1)=swapbytes(typecast(uint8(frame.Data(j:j+1)),'uint16'));
            obj.ANNMR(i,1:1)=swapbytes(typecast(uint8(frame.Data(j+2:j+3)),'uint16'));
            obj.DGNMR(i,1:1)=swapbytes(typecast(uint8(frame.Data(j+4:j+5)),'uint16'));
            j=j+6;
            
            for k=1:obj.PHNMR(i)
                m=swapbytes(typecast(uint8(frame.Data(j)),'uint8'));
                obj.CHNAM_PHNMR(i,k)=strtrim(string(char(uint8(frame.Data(j+1:j+m-1)))));%Might want to check if correct
                j=j+k+1;
            end
            for k=1:obj.ANNMR(i)
                m=swapbytes(typecast(uint8(frame.Data(j)),'uint8'));
                obj.CHNAM_ANNMR(i,k)=strtrim(string(char(uint8(frame.Data(j+1:j+m-1)))));%Might want to check if correct
                j=j+k+1;
            end
            for k=1:obj.DGNMR(i)
                m=swapbytes(typecast(uint8(frame.Data(j)),'uint8'));
                obj.CHNAM_DGNMR(i,k)=strtrim(string(char(uint8(frame.Data(j+1:j+m-1)))));%Might want to check if correct
                j=j+k+1;
            end

            for k=1:obj.PHNMR(i)
                obj.PHSCALE_1_0(i,k)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j),1,"uint8"))));%Might want to check if correct
                obj.PHSCALE_1_1(i,k)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j),2,"uint8"))));
                obj.PHSCALE_1_2(i,k)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j),3,"uint8"))));
                obj.PHSCALE_1_3(i,k)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j),4,"uint8"))));
                obj.PHSCALE_1_4(i,k)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j),5,"uint8"))));
                obj.PHSCALE_1_5(i,k)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j),6,"uint8"))));
                obj.PHSCALE_1_6(i,k)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j),7,"uint8"))));
                obj.PHSCALE_1_7(i,k)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j),8,"uint8"))));
                obj.PHSCALE_1_8(i,k)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j+1),1,"uint8"))));
                obj.PHSCALE_1_9(i,k)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j+1),2,"uint8"))));
                obj.PHSCALE_1_10(i,k)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j+1),3,"uint8"))));
                obj.PHSCALE_1_11_14(i,k)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j+1),[7 6 5 4],"uint8"))));
                obj.PHSCALE_1_15(i,k)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j+1),8,"uint8"))));
                obj.PHSCALE_1_16_18(i,k)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j+2),[3 2 1],"uint8"))));
                obj.PHSCALE_1_19(i,k)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j+2),4,"uint8"))));
                obj.PHSCALE_1_20_23(i,k)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j+2),[8 7 6 5],"uint8"))));
                obj.PHSCALE_1_24_31(i,k)=uint8(frame.Data(j+3));
                obj.PHSCALE_2(i,k)=swapbytes(typecast(uint8(frame.Data(j+4:j+7)),'single'));
                obj.PHSCALE_3(i,k)=swapbytes(typecast(uint8(frame.Data(j+8:j+11)),'single'));
                j=j+12;
            end

            for k=1:obj.ANNMR(i)
                obj.ANSCALE_B(i,k)=swapbytes(typecast(uint8(frame.Data(j:j+3)),'single'));
                obj.ANSCALE_M(i,k)=swapbytes(typecast(uint8(frame.Data(j+4:j+7)),'single'));   
                j=j+8;
            end

            for k=1:obj.DGNMR(i)
                obj.DIGUNIT0(i,k)=swapbytes(typecast(uint8(frame.Data(j:j+1)),'uint16'));
                obj.DIGUNIT1(i,k)=swapbytes(typecast(uint8(frame.Data(j+2:j+3)),'uint16'));   
                j=j+4;
            end

            obj.PMU_LAT(i)=swapbytes(typecast(uint8(frame.Data(j:j+3)),'single'));
            j=j+4;

            obj.PMU_LON(i)=swapbytes(typecast(uint8(frame.Data(j:j+3)),'single'));
            j=j+4;

            obj.PMU_ELEV(i)=swapbytes(typecast(uint8(frame.Data(j:j+3)),'single'));
            j=j+4;

            obj.SVC_CLASS=char(uint8(frame.Data(j)));
            j=j+1;

            obj.WINDOW(i)=swapbytes(typecast(uint8(frame.Data(j:j+3)),'uint32'));
            j=j+4;

            obj.GRP_DLY(i)=swapbytes(typecast(uint8(frame.Data(j:j+3)),'uint32'));
            j=j+4;

            obj.FNOM(i)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j),1,"uint8"))));
            j=j+1;

            obj.CFGCNT(i)=swapbytes(typecast(uint8(frame.Data(j:j+1)),'uint16'));
            j=j+2;

            end

            obj.DATA_RATE=swapbytes(typecast(uint8(frame.Data(j:j+1)),'uint16'));
            obj.CHK=swapbytes(typecast(uint8(frame.Data(j+2:j+3)),'uint16'));
        end
    end
end