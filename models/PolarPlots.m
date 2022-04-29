classdef PolarPlots < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties(Access=public)
        HandleToPlot;
        Mode ReferenceType=ReferenceType.None;
        ExtraAngle=0
        ID
        Freq
    end
        
    methods
        function obj = PolarPlots(HandleToPlot)
            arguments
                HandleToPlot CustomPolarPlot
            end
            obj.HandleToPlot=HandleToPlot;
        end

        function UpdateGraph(obj,data,list)
            arguments
                obj PolarPlots
                data PMU
                list
            end
                angle=data.data.PHASORS0(1,1);
                switch obj.Mode
                    case ReferenceType.Default
                        if ~isempty(data.data.FREQ)
                            angle=angle+((50-data.data.FREQ)*360);
                        end
                    case ReferenceType.CustomFreq
                        if ~isempty(data.data.FREQ) && ~isempty(obj.Freq)
                            angle=angle+((obj.Freq-data.data.FREQ)*360);
                        end
                    case ReferenceType.OtherPMU

                        if ~isempty(data.data.FREQ) && ~isempty(obj.ID) && isKey(list,obj.ID)
                            OtherDevice=list(obj.ID);
                            if ~isempty(OtherDevice) && ~isempty(OtherDevice.data) && ~isempty(OtherDevice.data.FREQ)
                            angle=angle+((OtherDevice.data.FREQ-data.data.FREQ)*360);
                            end
                        end
                end
                obj.HandleToPlot.UpdatePolarPlot(data.data.PHASORS1(1,1),angle);
        end
    end
end