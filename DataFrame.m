classdef DataFrame
    %DataFrame Summary of this class goes here
    %   Detailed explanation goes here

    properties(Access=public)

           sha256 char              %Used to determine if new frame has different values

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

                                    %Bit mapped flags.
         STAT_DATA_ERROR uint8;     % Bit 15–14: Data error: 00 = good measurement data, no errors
                                    %                        01 = PMU error. No information about data
                                    %                        10 = PMU in test mode (do not use values) or
                                    %                   absent data tags have been inserted (do not use values)
                                    %                        11 = PMU error (do not use values)
         STAT_PMU_SYNC uint8;       % Bit 13: PMU sync, 0 when in sync with a UTC traceable time source
         STAT_DATA_SORTING uint8;   % Bit 12: Data sorting, 0 by time stamp, 1 by arrival
         STAT_PMU_TRIGGER uint8;    % Bit 11: PMU trigger detected, 0 when no trigger
         STAT_CNF_CHANGE uint8;     % Bit 10: Configuration change, set to 1 for 1 min to advise configuration will change, and
                                    % clear to 0 when change effected.
         STAT_DATA_MODIFIED uint8;  % Bit 09: Data modified, 1 if data modified by post processing, 0 otherwise
         STAT_PMU_TQ uint8;         % Bits 08–06: PMU Time Quality. Refer to codes in Table 7.
         STAT_UNLOCKED_TIME uint8;  % Bits 05–04: Unlocked time: 00 = sync locked or unlocked < 10 s (best quality)
                                    % \01 = 10 s ≤ unlocked time < 100 s
                                    % 10 = 100 s < unlock time ≤ 1000 s
                                    % 11 = unlocked time > 1000 s
        STAT_TRIGGER_REASON uint8;  % Bits 03–00: Trigger reason:
                                    % 1111–1000: Available for user definition
                                    % 0111: Digital 0110: Reserved
                                    % 0101: df/dt High 0100: Frequency high or low
                                    % 0011: Phase angle diff 0010: Magnitude high
                                    % 0001: Magnitude low 0000: Manual

        PHASORS0;                   %Data type indicated by the FORMAT field in configuration 1, 2, and 3 frames
        PHASORS1;                   % 16-bit integer values:
                                    % Rectangular format:
                                    % ―real and imaginary, real value first
                                    % ―16-bit signed integers, range –32 767 to +32 767
                                    % Polar format:
                                    % ―magnitude and angle, magnitude first
                                    % ―magnitude 16-bit unsigned integer range 0 to 65535
                                    % ―angle 16-bit signed integer, in radians × 10 4
                                    % , range –31 416 to +31 416
                                    % 32-bit values in IEEE floating-point format:
                                    % Rectangular format:
                                    % ―real and imaginary, in engineering units, real value first
                                    % Polar format:
                                    % ―magnitude and angle, magnitude first and in engineering units
                                    % ―angle in radians, range –π to + π

        FREQ;                       %Frequency deviation from nominal, in mHz
                                    % Range–nominal (50 Hz or 60 Hz) –32.767 to +32.767 Hz
                                    % 16-bit integer or 32-bit floating point
                                    % 16-bit integer: 16-bit signed integers, range –32 767 to +32 767
                                    % 32-bit floating point: actual frequency value in IEEE floating-point format.
                                    % Data type indicated by the FORMAT field in configuration 1, 2, and 3 frames

        DFREQ;                      %ROCOF, in hertz per second times 100
                                    %Range –327.67 to +327.67 Hz per second
                                    %Can be 16-bit integer or IEEE floating point, same as FREQ above. Data type indicated
                                    %by the FORMAT field in configuration 1, 2, and 3 frames

        ANALOG;                     %Analog word. 16-bit integer. It could be sampled data such as control signal or
                                    %transducer value. Values and ranges defined by user.
                                    %Can be 16-bit integer or IEEE floating point. Data type indicated by the FORMAT field
                                    %in configuration 1, 2, and 3 frames

        DIGITAL uint16;             %Digital status word. It could be bit mapped status or flag. Values and ranges defined by
                                    %user.
    end

    methods
        function obj = DataFrame(frame,cnf)
            obj.sha256=SHA256(uint8(frame.Data));

            obj.SYNCFRAMETYPE=uint8(bin2dec(sprintf('%d',bitget(frame.Data(2),[7 6 5],"uint8"))));%SYNC TYPE field
            obj.SYNCVERSION=uint8(bin2dec(sprintf('%d',bitget(frame.Data(2),[4 3 2 1],"uint8"))));
            obj.FRAMESIZE=swapbytes(typecast(uint8(frame.Data(3:4)),'uint16'));%FRAMESIZE field
            obj.ID_CODE_SOURCE=swapbytes(typecast(uint8(frame.Data(5:6)),'uint16'));%IDCODE field
            obj.SOC=datetime( swapbytes(typecast(uint8(frame.Data(7:10)),'uint32')), 'ConvertFrom', 'posixtime');%SOC field
            obj.MTQ=uint8(frame.Data(11));%FRASEC field Bits 31–24 
            obj.FRACSEC=swapbytes(typecast(uint8([0,frame.Data(12:14)]),'uint32'));%FRASEC field Bits 23–00
            j=15;
            for i=1:cnf.NUM_PMU
                obj.STAT_DATA_ERROR(i)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j),[8 7],"uint8")))); 
                obj.STAT_PMU_SYNC(i)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j),[6],"uint8"))));     
                obj.STAT_DATA_SORTING(i)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j),[5],"uint8"))));     
                obj.STAT_PMU_TRIGGER(i)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j),[4],"uint8"))));      
                obj.STAT_CNF_CHANGE(i)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j),[3],"uint8"))));       
                obj.STAT_DATA_MODIFIED(i)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j),[2],"uint8"))));    
                obj.STAT_PMU_TQ(i)=uint8(bin2dec(sprintf('%d',bitget(swapbytes(typecast(uint8(frame.Data(j:j+1)),'uint16')),[9 8 7],"uint16"))));
                obj.STAT_UNLOCKED_TIME(i)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j+1),[6 5],"uint8"))));    
                obj.STAT_TRIGGER_REASON(i)=uint8(bin2dec(sprintf('%d',bitget(frame.Data(j+1),[4 3 2 1],"uint8"))));
                j=j+2;

                for k=1:cnf.PHNMR
                    if cnf.FORMAT_PHASORS(i)==1 %1 = floating point
                        if cnf.FORMAT_FORM(i)==1%1 = magnitude and angle (polar)
                            obj.PHASORS0(i,k)=swapbytes(typecast(uint8(frame.Data(j:j+3)),'single'));
                            obj.PHASORS1(i,k)=swapbytes(typecast(uint8(frame.Data(j+4:j+7)),'single'));
                        elseif cnf.FORMAT_FORM(i)==0%0 = phasor real and imaginary (rectangular)
                            obj.PHASORS0(i,k)=swapbytes(typecast(uint8(frame.Data(j:j+3)),'single'));
                            obj.PHASORS1(i,k)=swapbytes(typecast(uint8(frame.Data(j+4:j+7)),'single'));
                        end
                        j=j+8;
                    elseif cnf.FORMAT_PHASORS(i)==0%0 = 16-bit integer 
                        if cnf.FORMAT_FORM(i)==1%1 = magnitude and angle (polar)
                            obj.PHASORS0(i,k)=swapbytes(typecast(uint8(frame.Data(j:j+1)),'uint16'));
                            obj.PHASORS1(i,k)=swapbytes(typecast(uint8(frame.Data(j+2:j+3)),'int16'));
                        elseif cnf.FORMAT_FORM(i)==0%0 = phasor real and imaginary (rectangular)
                            obj.PHASORS0(i,k)=swapbytes(typecast(uint8(frame.Data(j:j+1)),'int16'));
                            obj.PHASORS1(i,k)=swapbytes(typecast(uint8(frame.Data(j+2:j+3)),'int16'));
                        end
                        j=j+4;
                    end
                end
                
                if cnf.FORMAT_FREQ(i)==1% 1 = floating point
                obj.FREQ(i)=swapbytes(typecast(uint8(frame.Data(j:j+3)),'single'));
                obj.DFREQ(i)=swapbytes(typecast(uint8(frame.Data(j+4:j+7)),'single'));
                j=j+8;
                elseif cnf.FORMAT_FREQ(i)==0% 0 = 16-bit integer
                obj.FREQ(i)=swapbytes(typecast(uint8(frame.Data(j:j+1)),'int16'));
                obj.DFREQ(i)=swapbytes(typecast(uint8(frame.Data(j+2:j+3)),'int16'));
                j=j+4;
                end

                for k=1:cnf.ANNMR
                    if cnf.FORMAT_ANALOG(i)==1 %1 = floating point
                        obj.ANALOG(i,k)=swapbytes(typecast(uint8(frame.Data(j:j+3)),'single'));
                        j=j+4;
                    elseif cnf.FORMAT_ANALOG(i)==0%0 = 16-bit integer 
                        obj.ANALOG(i,k)=swapbytes(typecast(uint8(frame.Data(j:j+1)),'int16'));
                        j=j+2;
                    end
                end

                for k=1:cnf.DGNMR
                    obj.DIGITAL(i,k)=swapbytes(typecast(uint8(frame.Data(j:j+1)),'uint16'));
                    j=j+2;
                end

            end
            obj.CHK=swapbytes(typecast(uint8(frame.Data(end-1:end)),'uint16'));
        end

    end
end