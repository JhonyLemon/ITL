classdef AnalogConversionFactor < uint8
    %Conversion factor for analog channels
   enumeration
      singlePointOnWave     (0)     %0―single point-on-wave
      rmsOfAnalog           (1)     %1―rms of analog input
      PeakOfAnalog          (2)     %2―peak of analog input
   end
end

