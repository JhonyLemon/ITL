classdef TriggerReason < uint8
    % Trigger reason
    % Bits 0–3―Trigger reason: a 4-bit code indicating the initial cause of a trigger
   enumeration
     Digital            (0b0111)    %Digital
     Reserved           (0b0110)    %Reserved
     df_dt_High         (0b0101)    %df/dt High 
     FrequencyHighOrLow (0b0100)    %Frequency high or low
     PhaseAngleDiff     (0b0011)    %Phase angle diff 
     MagnitudeHigh      (0b0010)    %Magnitude high
     MagnitudeLow       (0b0001)    %Magnitude low
     Manual             (0b0000)    %Manual
   end
end

