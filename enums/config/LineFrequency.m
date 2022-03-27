classdef LineFrequency < uint16
    %Nominal line frequency code (16 bit unsigned integer)
   enumeration
      FundamentalFreq50   (1)     %Fundamental frequency = 50 Hz
      FundamentalFreq60   (0)     %Fundamental frequency = 60 Hz
   end
end
