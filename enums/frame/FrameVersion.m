classdef FrameVersion < uint8
    %Class containing frame versions
    % Version number, in binary (1–15)
    % Version 1 (0001) for messages defined in IEEE Std C37.118-2005 [B6].
    % Version 2 (0010) for messages added in this revision,
    % IEEE Std C37.118.2-2011.
   enumeration
      Version1 (1)        %Version 1 for messages defined in IEEE Std C37.118-2005 [B6].
      Version2 (2)        %Version 2 for messages added in this revision,
   end

end