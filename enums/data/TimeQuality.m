classdef TimeQuality < uint8
    % PMU Time Quality
    % Bits 6–8―PMU_TQ (PMU Time Quality): This 3-bit time quality code shall indicate the maximum
    % uncertainty in the measurement time at the time of measurement. It shall be derived from the time source
    % and be adjusted to include uncertainties in the PMU measuring process. This time quality information
    % indicates time quality at all times, both when time is considered locked and unlocked. The codes and their
    % range of time uncertainty indication are detailed in Table 7. When the time quality is not known during
    % startup, a code of 111b shall be used. A time quality of 000b indicates a previous version of this message
    % that does not indicate time quality in these bits.
   enumeration
    TimeQuality7 (7) %Estimated maximum time error > 10 ms or time error unknown
    TimeQuality6 (6) %Estimated maximum time error < 10 ms
    TimeQuality5 (5) %Estimated maximum time error < 1 ms
    TimeQuality4 (4) %Estimated maximum time error < 100 μs
    TimeQuality3 (3) %Estimated maximum time error < 10 μs
    TimeQuality2 (2) %Estimated maximum time error < 1 μs
    TimeQuality1 (1) %Estimated maximum time error < 100 ns
    TimeQuality0 (0) %Not used (indicates code from previous version of profile)
   end
end

