classdef PMU
    %Class for holding data recived from UDP datagram
    %   Class contains PMU configuration and data 

    properties(Access=public)
        cnf_version uint8=0;
        cnf_3 CNF_1;
        cnf_2 CNF_2;
        cnf_1 CNF_3;
        data DataFrame;
        cmd CommandFrame;
        header HeaderFrame;
    end

    methods
        function obj=PMU()
        end

        function obj=InsertFrame(obj,frame)
            %if crc_16_CCITT_8bit(frame(1:end-2))==swapbytes(typecast(uint8(frame.Data(end-1:end)),'uint16'))
               switch(uint8(bin2dec(sprintf('%d',bitget(frame.Data(2),[7 6 5],"uint8")))))%Checking frame type
                   case 0%Data Frame
                       if obj.cnf_version~=0%if configuration frame set
                           if obj.cnf_version==1
                                cnf=obj.cnf_1;
                           elseif obj.cnf_version==2
                               cnf=obj.cnf_2;
                           elseif obj.cnf_version==3  
                               cnf=obj.cnf_3;
                           end
                           data = DataFrame(frame,cnf);
                           if ~obj.IsEqual(obj.data,data)
                                obj.data=data;
                           end
                       end

                   case 1%Header Frame
                       header=HeaderFrame(frame);
                   case 2%Configuration Frame 1
                       cnf = CNF_1(frame);
                       if ~obj.IsEqual(obj.cnf_1,cnf)
                            obj.cnf_1=cnf;
                            obj.cnf_version=1;
                       end
                   case 3%Configuration Frame 2
                       cnf = CNF_2(frame);
                       if ~obj.IsEqual(obj.cnf_2,cnf)
                            obj.cnf_2=cnf;
                            obj.cnf_version=2;
                       end
                   case 5%Configuration Frame 3
                       cnf = CNF_3(frame);
                   case 4%Command Frame
    
               end
           %end
        end

        function id=GetID(obj)
            if(obj.cnf_1~=null)
                id=obj.cnf_1.ID_CODE_SOURCE;
            elseif(obj.cnf_2~=null)
                id=obj.cnf_1.ID_CODE_SOURCE;
            elseif(obj.cnf_3~=null) 
                id=obj.cnf_1.ID_CODE_SOURCE;
            else
                id=null;
            end
        end

        function isEq=IsEqual(obj,this,other)
            isEq=false;
            if ~isempty(this) && ~isempty(other)
                if this.sha256==other.sha256
                    isEq=true;
                end
            end
        end
   
    end
end