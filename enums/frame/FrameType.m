classdef FrameType < uint8
    %Class containing frame types
    % 000: Data Frame
    % 001: Header Frame
    % 010: Configuration Frame 1
    % 011: Configuration Frame 2
    % 101: Configuration Frame 3
    % 100: Command Frame (received message)
   enumeration
      DataFrame (0)                 %Data Frame
      HeaderFrame (1)               %Header Frame
      ConfigurationFrame1 (2)       %Configuration Frame 1
      ConfigurationFrame2 (3)       %Configuration Frame 1
      ConfigurationFrame3 (5)       %Configuration Frame 1
      CommandFrame (4)              %Send CFG-3 frame
   end

end