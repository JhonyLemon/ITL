classdef UnlockedTime < uint8
    % Unlocked time
    % Bits 4–5―Unlocked time: indicates a range of seconds since loss of synch was detected. This counts
    % seconds from the loss of lock on time synch until it is reacquired. When sync is reacquired, the code goes to
    % 00. The criteria for determining when lock on time synch is achieved or lost is not specified in this
    % standard. This will be normally implemented as follows:
   enumeration
    UnlockedTime0 (0) %Locked or unlocked less than 10 s
    UnlockedTime1 (1) %Unlocked 10 s or longer but less than 100 s
    UnlockedTime2 (2) %Unlocked 100 s or longer but less than 1000 s
    UnlockedTime3 (3) %Unlocked 1000 s or more
   end
end

