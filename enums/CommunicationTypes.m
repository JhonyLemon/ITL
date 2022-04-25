classdef CommunicationTypes < uint8
    %Class containing types of communication
   enumeration
      SpontaneousUDP (0)                 %Spontaneous data transmission method
      CommandedUDP (1)                   %UDP-only method
      CommandedTCP (2)                   %TCP-only method
      CommandedTCPwithUDP (3)            %TCP/UDP method
   end

end

