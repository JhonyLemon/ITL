classdef DataModified < uint8
    % Data modified indicator
    % Bit 9―Data modified indicator. If phasor data in frame is modified by a post-processing device such as a
    % PDC, this bit shall be set to 1. This shall include data points inserted by interpolation or lost point
    % reconstruction, and data modified by down-sampling methods, offset adjustment, or error correction. In all
    % other cases this bit shall be set to 0. It shall not be used to indicate conversions such as polar-rectangular
    % and integer-floating point.
   enumeration
      Modified (1)      %phasor data in frame is modified
      NotModified (0)   %phasor data in frame is not modified
   end
end



