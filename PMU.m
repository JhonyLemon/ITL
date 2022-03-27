classdef PMU
    %Class for holding data recived from UDP datagram
    %   Class contains PMU configuration and data 

    properties(Access=public)
        sourceIP string;
        sourcePort uint16;
        cnf_version uint8=0;
        cnf ConfigFrame;
        data DataFrame;
        cmd CommandFrame;
        header HeaderFrame;
        isChanged;
    end

    methods
        function obj=PMU()
            obj.isChanged=false;
        end

        function obj=InsertFrame(obj,frame)
            obj.sourceIP=frame.SenderAddress;
            obj.sourcePort=frame.SenderPort;
            if crc_16_CCITT_8bit(frame.Data(1:end-2))==swapbytes(typecast(uint8(frame.Data(end-1:end)),'uint16'))
            sha=SHA256(frame.Data(15:end-2));
               switch(uint8(bin2dec(sprintf('%d',bitget(frame.Data(2),[7 6 5],"uint8")))))%Checking frame type
                   case 0%Data Frame
                       if obj.cnf_version~=0%if configuration frame set
                           if ~obj.IsEqual(obj.data,sha)
                                data=DataFrame(frame,obj.cnf,obj.cnf_version);
                                data.sha256=sha;
                                if data.CheckQuality()==true
                                obj.data=data;
                                obj.isChanged=true;
                                end
                           end
                       end
                   case 1%Header Frame
                       if ~obj.IsEqual(obj.cnf,sha)
                            obj.header=HeaderFrame(frame);
                            obj.header.sha256=sha;
                       end
                   case 2%Configuration Frame 1
                       if ~obj.IsEqual(obj.cnf,sha)
                            obj.cnf=CNF_1(frame);
                            obj.cnf.sha256=sha;
                            obj.cnf_version=1;
                       end
                   case 3%Configuration Frame 2
                       if ~obj.IsEqual(obj.cnf,sha)
                            obj.cnf=CNF_2(frame);
                            obj.cnf.sha256=sha;
                            obj.cnf_version=2;
                       end
                   case 5%Configuration Frame 3
                       if ~obj.IsEqual(obj.cnf,sha)
                            obj.cnf=CNF_3(frame);
                            obj.cnf.sha256=sha;
                            obj.cnf_version=3;
                       end
               end
           end
        end

        function id=GetID(obj)
            id=null;
            if(obj.cnf_version~=0)
                id=obj.cnf.ID_CODE_SOURCE;
            end
        end

        function isEq=IsEqual(obj,sha_this,sha_other)
            isEq=false;
            if ~isempty(sha_this) && ~isempty(sha_other)
                if sha_this.sha256==sha_other
                    isEq=true;
                end
            end
        end
   
    end
end