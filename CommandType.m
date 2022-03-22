classdef CommandType < uint16
    %Class containing command types
    % 0000 0000 0000 0001 Turn off transmission of data frames.
    % 0000 0000 0000 0010 Turn on transmission of data frames.
    % 0000 0000 0000 0011 Send HDR frame.
    % 0000 0000 0000 0100 Send CFG-1 frame.
    % 0000 0000 0000 0101 Send CFG-2 frame.
    % 0000 0000 0000 0110 Send CFG-3 frame (optional command).
    % 0000 0000 0000 1000 Extended frame.
    % 0000 0000 xxxx xxxx All undesignated codes reserved.
    % 0000 yyyy xxxx xxxx All codes where yyyy ≠ 0 available for user designation.
    % zzzz xxxx xxxx xxxx All codes where zzzz ≠ 0 reserved.
   enumeration
      TranOFF (1)       %Turn off transmission of data frames
      TranON (2)        %Turn on transmission of data frames
      SendHDR (3)       %Send HDR frame
      SendCFG_1 (4)     %Send CFG-1 frame
      SendCFG_2 (5)     %Send CFG-2 frame
      SendCFG_3 (6)     %Send CFG-3 frame
      ExtFrame (7)      %Extended frame
   end

end