classdef PMU
    %Class for holding data recived from UDP datagram
    %   Class contains PMU configuration and data 

    properties(Access=public)
        CNF_3;
        CNF_2;
        CNF_1;
        DATA;
    end

    methods
        function obj=PMU()
        obj.CNF_1=CNF_1();
        obj.CNF_2=CNF_2();
        obj.CNF_3=CNF_3();
        obj.DATA=DataFrame();
        end

        function InsertFrame(obj,frame)
           switch(uint8(bin2dec(sprintf('%d',bitget(frame.Data(2),[7 6 5],"uint8")))))%Checking frame type
               case 0%Data Frame
                   data = DataFrame(frame);
               case 1%Header Frame

               case 2%Configuration Frame 1
                   cnf = CNF_1(frame);
               case 3%Configuration Frame 2
                   cnf = CNF_2(frame);
               case 5%Configuration Frame 3
                   cnf = CNF_3(frame);
               case 4%Command Frame

           end            
        end
        function InsertDataFrame(obj,data,frame)
            
        end
            
    end
end