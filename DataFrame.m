classdef DataFrame < Frame
    %DataFrame Summary of this class goes here
    %   Detailed explanation goes here

    properties(Access=public)
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
        function obj = DataFrame(frame,cnf,version)
            obj@Frame(frame);
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