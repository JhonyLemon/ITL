classdef Trigger < uint8
    %PMU Trigger
    % PMU Trigger pick-up: set to indicate a trigger condition has been detected for PMUs that have
    % trigger capability. The bit shall be set for a mandatory set period of at least one data frame or one second,
    % whichever is longer. It may remain set as long as the trigger condition is detected or may be cleared after
    % this mandatory set period to allow for detection of other triggers.
   enumeration
      NoTriggerDetected (0)   %no trigger
      TriggerDetected (1)     %trigger
   end
end

