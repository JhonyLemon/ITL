classdef HeaderFrame < Frame
    properties(Access=public)
            DATA char;              %ASCII character, 1st byte.
    end

    methods
        function obj = HeaderFrame(frame)
            obj@Frame(frame);
            obj.DATA=char(uint8(frame.Data(15:obj.FRAMESIZE-2)));
        end
    end
end