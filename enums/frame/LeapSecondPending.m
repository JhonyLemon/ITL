classdef LeapSecondPending < uint8
    %Leap Second Pending―shall be set not more than 60 s nor less than 1 s before a leap
    %second occurs, and cleared in the second after the leap second occurs
   enumeration
      Pending (1)           %pending
      NotPending (0)        %not pending
   end
end
