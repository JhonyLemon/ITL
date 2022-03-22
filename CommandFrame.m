classdef CommandFrame

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

            CMD CommandType;        %Command being sent to the PMU/PDC (0).

            EXTFRAME uint16;        %0–65518 Extended frame data, 16-bit words, 0 to 65518 bytes as indicated by frame size, data user defined.
    end

    methods
        function obj = CommandFrame()

        end

        
    end
end