classdef Frame
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here

    properties
           sha256 char              %Used to determine if new frame has different values

                                    %Frame synchronization word.
                                    %Leading byte: AA hex
                                    % Second byte: Frame type and version, divided as follows:
                                    % Bit 7: Reserved for future definition, must be 0 for this standard version.
           SYNCFRAMETYPE FrameType; % Bits 6–4: 000: Data Frame
                                    % 001: Header Frame
                                    % 010: Configuration Frame 1
                                    % 011: Configuration Frame 2
                                    % 101: Configuration Frame 3
                                    % 100: Command Frame (received message)
           SYNCVERSION FrameVersion;% Bits 3–0: Version number, in binary (1–15)
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
        
            MTQ_L_S_DIRECTION LeapSecondDirection;%Leap Second Direction―0 for add, 1 for delete
            MTQ_L_S_OCCURRED LeapSecondOccurred; %Leap Second Occurred―set in the first second after the leap second occurs and remains set for 24 h
            MTQ_L_S_PENDING LeapSecondPending;  %Leap Second Pending―shall be set not more than 60 s nor less than 1 s before a leap second occurs, and cleared in the second after the leap second occurs
            MTQ_L_S_INDICATOR MessageTimeQuality;%Message Time Quality indicator code
            FRACSEC uint32;         %24-bit integer number. When divided by TIME_BASE yields the actual fractional second. FRACSEC used in all messages to and from a given PMU shall use the same TIME_BASE that is provided in the configuration message from that PMU.
        
            CHK uint16;             %CRC-CCITT, 16-bit unsigned integer
    end

    methods
        function obj = Frame(NameValueArgs)
            arguments
                NameValueArgs.Frame
            end
            if isfield(NameValueArgs,'frame')
                obj.SYNCFRAMETYPE=uint8(bin2dec(sprintf('%d',bitget(NameValueArgs.Frame.Data(2),[7 6 5],"uint8"))));%SYNC TYPE field
                obj.SYNCVERSION=uint8(bin2dec(sprintf('%d',bitget(NameValueArgs.Frame.Data(2),[4 3 2 1],"uint8"))));
                obj.FRAMESIZE=swapbytes(typecast(uint8(NameValueArgs.Frame.Data(3:4)),'uint16'));%FRAMESIZE field
                obj.ID_CODE_SOURCE=swapbytes(typecast(uint8(NameValueArgs.Frame.Data(5:6)),'uint16'));%IDCODE field
                obj.SOC=datetime( swapbytes(typecast(uint8(NameValueArgs.Frame.Data(7:10)),'uint32')), 'ConvertFrom', 'posixtime');%SOC field
                obj.MTQ_L_S_DIRECTION=uint8(bin2dec(sprintf('%d',bitget(NameValueArgs.Frame.Data(11),[7],"uint8"))));
                obj.MTQ_L_S_OCCURRED=uint8(bin2dec(sprintf('%d',bitget(NameValueArgs.Frame.Data(11),[6],"uint8"))));
                obj.MTQ_L_S_PENDING=uint8(bin2dec(sprintf('%d',bitget(NameValueArgs.Frame.Data(11),[5],"uint8"))));
                obj.MTQ_L_S_INDICATOR=uint8(bin2dec(sprintf('%d',bitget(NameValueArgs.Frame.Data(11),[4 3 2 1],"uint8"))));
                obj.FRACSEC=swapbytes(typecast(uint8([0,NameValueArgs.Frame.Data(12:14)]),'uint32'));%FRASEC field Bits 23–00
                obj.CHK=swapbytes(typecast(uint8(NameValueArgs.Frame.Data(end-1:end)),'uint16'));
            end
        end

        function isValid=CheckQuality(obj)
            isValid=true;
        end
    end
end