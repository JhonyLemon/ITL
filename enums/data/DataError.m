classdef DataError < uint8
    %Class containing STAT data error fields
    % Bit 15–Bit 14 Data Error Indicator: set as noted in Table 6. A PDC is expected to receive data from several
    % PMUs and transmit the aligned data to its destination(s). However, due to the latency requirements of
    % applications, the PDC will not wait indefinitely for the arriving data, but implement a wait time. Once the
    % wait time is over, the PDC will send whatever data has arrived within this interval. The IEEE C37.118
    % message format requires sending fixed-size data frames, so if any data that goes in a frame is not present
    % when the frame is assembled, the PDC will need to provide a filler. So a receiving device will not interpret
    % this filler as data, the PDC must set these bits to 10 in the status word to indicate the data in this PMU
    % section is not valid. In addition, the data itself can be written as invalid. For floating-point data NaN (not a
    % number) will be inserted for the absent data. For fixed-point data in rectangular format the PDC will use
    % 0x8000 (–32768) as the substitute for the absent data. The standard allows values of +32 767 to –32 767 for
    % valid data (see Table 6). For fixed-point data in polar format all values are permissible for the magnitude
    % field. However, the angle field is re stricted to ±31416. A value of 0x8000 (–32768) used in the angle field
    % will be used to signify absent data.
   enumeration
      NoErrors (0)                          %00 = good measurement data, no errors
      ErrorNoInformationAboutData (1)       %01 = PMU error. No information about data
      ErrorTestModeOrAbsentTags (2)         %10 = PMU in test mode (do not use values) or absent data tags have been inserted (do not use values)
      Error (3)                             %11 = PMU error (do not use values)
   end

end

