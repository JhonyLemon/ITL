classdef ConfigFrame < Frame
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here

    properties
          TIME_BASE_FLAGS uint8;%Time base flags
          TIME_BASE uint32;     %24-bit unsigned integer, which is the subdivision of the second that the FRACSEC is based on.

          NUM_PMU uint16;       %The number of PMUs included in the data frame. No limit specified. The actual limit will be determined by the limit of 65 535 bytes in one frame ("FRAMESIZE" field)
                                
          STN char;             %Station Name

          ID_CODE_DATA int16;   %Data stream ID number

          FORMAT_FREQ FormatFreqDfreq;    % 0 = FREQ/DFREQ 16-bit integer, 1 = floating point
          FORMAT_ANALOG FormatAnalog;  % 0 = analogs 16-bit integer, 1 = floating point
          FORMAT_PHASORS FormatPhasors; % 0 = phasors 16-bit integer, 1 = floating point
          FORMAT_FORM FormatForm;    % 0 = phasor real and imaginary (rectangular), 1 = magnitude and angle (polar)
           
          PHNMR uint16;         %Number of phasors―2-byte integer.

          ANNMR uint16;         %Number of analog values―2-byte integer.

          DGNMR uint16;         %Number of digital status words―2-byte integer.

          CHNAM_PHNMR string;   %Phasors channel names
          CHNAM_ANNMR string;   %Analogs channel names
          CHNAM_DGNMR string;   %Digitals channel names


          DIGUNIT0 uint16;      %Mask words for digital status words.
          DIGUNIT1 uint16;      %Mask words for digital status words.

          FNOM LineFrequency;          %Nominal line frequency Bits 15–1: Reserved Bit 0: 1―Fundamental frequency = 50 Hz 0―Fundamental frequency = 60 Hz
          
          CFGCNT uint16;        %Configuration change count is incremented each time a change is made in the PMU


          DATA_RATE int16;      %Rate of phasor data transmissions―2-byte integer word (–32 767 to +32 767)      
    end

    methods
        function obj = ConfigFrame(frame)
            obj@Frame("Frame",frame);
        end
    end
end