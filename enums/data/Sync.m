classdef Sync < uint8
    %PMU Sync Error
    % PMU Sync Error: set to 1 to indicate the PMU has detected a loss of external time synchronization
    % such as a loss of satellite tracking or a time input connection failure. It shall be used both when the time
    % synchronization input fails and when the source of time synchronization loses lock to UTC traceable time.
    % The measuring PMU shall set this bit to 1 when the 4-bit time quality field in the FRACSEC field becomes
    % non-zero. A DC may also set Bit 13 to 1 if it detects a synchronization error in the data stream from a
    % particular PMU. The length of time between detecting a sync error and setting Bit 13 to 1 shall not exceed
    % the time for the estimated time error to exceed 31 μs in a 50 Hz system or 26 μs in a 60 Hz system
    % (equivalent to 1% TVE due to phase only) or 1 min, whichever is less.
   enumeration
      PmuNotInSync (1) %PMU has detected a loss of external time synchronization such as a loss of satellite tracking or a time input connection failure.
      PmuInSync (0)    %PMU in Sync
   end

end

