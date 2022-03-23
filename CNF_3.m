classdef CNF_3 < ConfigFrame
    %CNF_3 Summary of this class goes here
    %   Detailed explanation goes here

    properties(Access=public)
        CONT_IDX uint16;        %Continuation index for fragmented frames:
                                % 0: only frame in configuration, no further frames
                                % 1: first frame in series, more to follow
                                % 2–65534: number of each succeeding frame, in order
                                % 65535 (hex FFFF): last frame in series


        G_PMU_ID uint16;        %This 128-bit Global PMU ID shall be a user-assigned value. It shall be stored in the
                                % PMU or other sending device so it can be sent with this configuration 3 message. It
                                % allows uniquely identifying PMUs in a system that has more than 65535 PMUs. The
                                % coding for the 16 bytes is left to the user for assignment.

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
        PHSCALE_1_0 uint8;      % 0 Not used, reserved
        PHSCALE_1_1 uint8;      % 1 Up sampled with interpolation
        PHSCALE_1_2 uint8;      % 2 Upsampled with extrapolation
        PHSCALE_1_3 uint8;      % 3 Down sampled by reselection (selecting every Nth sample)
        PHSCALE_1_4 uint8;      % 4 Down sampled with FIR filter
        PHSCALE_1_5 uint8;      % 5 Down sampled with non-FIR filter
        PHSCALE_1_6 uint8;      % 6 Filtered without changing sampling
        PHSCALE_1_7 uint8;      % 7 Phasor magnitude adjusted for calibration
        PHSCALE_1_8 uint8;      % 8 Phasor phase adjusted for calibration
        PHSCALE_1_9 uint8;      % 9 Phasor phase adjusted for rotation ( ±30º, ±120º, etc.)
        PHSCALE_1_10 uint8;     % 10 Pseudo-phasor value (combined from other phasors)
        PHSCALE_1_11_14 uint8;  % 11–14 Reserved for future assignment
        PHSCALE_1_15 uint8;     % 15 Modification applied, type not here defined
                                % Third byte: phasor type indication (Bit 0 is the LSB, Bit 7 is the MSB)
        PHSCALE_1_20_23 uint8;  % Bits 07–04: Reserved for future use
        PHSCALE_1_19 uint8;     % Bit 03: 0―voltage; 1―current.
        PHSCALE_1_16_18 uint8;  % Bits 02–00: Phasor component, coded as follows
                                % 111: Reserved
                                % 110: Phase C
                                % 101: Phase B
                                % 100: Phase A
                                % 011: Reserved
                                % 010: Negative sequence
                                % 001: Positive sequence
                                % 000: Zero sequence
        PHSCALE_1_24_31 uint8;  % Fourth byte: available for user designation
                                % Second and third 4-byte words
                                % For phasor X = Xm e jφ, this defines the scaling Y and angle offset θ to be applied to the
                                % phasor as follows:
                                % X' = Y × Xm e j (φ–
                                % θ)
        PHSCALE_2 single;       % The second 4-byte word is the scale factor Y in 32-bit IEEE floating point. This scales
                                % phasor data to primary volts or amperes. If phasors are transmitted in floating-point
                                % format and scaled already, this value shall be set to 1.
        PHSCALE_3 single;       % The third 4-byte word is the phasor angle adjustment θ in radians represented in
                                % 32-bit IEEE floating point. If phasors are transmitted in floating-point format and
                                % scaled already, this value shall be set to 0

                                %Linear scaling for analog channels. For analog value X, this defines scale M and offset
                                % B for X' = M × X + B.
        ANSCALE_M single;       % First 4 bytes: Magnitude scaling M in 32-bit floating point.
        ANSCALE_B single;       % Last 4 bytes: Offset B in 32-bit floating point.

        PMU_LAT single;         %PMU Latitude in degrees, range –90.0 to +90.0. Positive values are N of equator.
                                % WGS 84 datum. Number in 32-bit IEEE floating-point format. For unspecified
                                % locations, infinity shall be used.

        PMU_LON single;         %PMU Longitude in degrees, range –179.99999999 to +180. Positive values are E of
                                % the prime meridian. WGS 84 datum. Number in 32-bit IEEE floating-point format.
                                % For unspecified locations, infinity shall be used.

        PMU_ELEV single;        %PMU Elevation in meters, Positive values are above mean sea level. WGS 84 datum.
                                % Number in 32-bit IEEE floating-point format. For unspecified locations, infinity shall
                                % be used.
                                           
        SVC_CLASS char;         %Service class, as defined in IEEE Std C37.118.1, a single ASCII character. In 2011 it
                                % is M or P.

        WINDOW int32;           %Phasor measurement window length including all filters and estimation windows in
                                % effect. Value is in microseconds, 4-byte signed integer value (to nearest
                                % microsecond). (For information only, any required compensation is already applied to
                                % the measurement.)

        GRP_DLY  int32;         %Phasor measurement group delay including all filters and estimation windows in
                                % effect. Value is in microseconds, 4-byte signed integer value (to nearest
                                % microsecond). (For information only, any required compensation is already applied to
                                % the measurement.)
    end

    methods
        function obj = CNF_3(frame)
            obj@ConfigFrame(frame);
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
        end
    end
end