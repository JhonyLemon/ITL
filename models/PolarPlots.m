classdef PolarPlots < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties(Access=public)
        HandleToPlot;
        Mode ReferenceType=ReferenceType.None;
        ExtraAngle=0
        IsValid=true;
        data PMU
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

        function [mag,ang]=PhasorToMagAndAngle(obj,data)
            arguments
                obj PolarPlots
                data PMU
            end
            mag=data.data.PHASORS0(1,1);
            ang=data.data.PHASORS1(1,1);
            if (data.cnf_version==2 || data.cnf_version==1) && data.cnf.FORMAT_FORM==0
               comp = complex(mag,ang);
                mag = abs(comp); %magnitude
                ang = angle(comp); %phase angle 
            elseif data.cnf_version==3
                error("Not implemented");
            end
        end

        function isValid=CheckQuality(obj)
            isValid=true;
            if ~isempty(obj.data.data) && ~isempty(obj.data.data.STAT_DATA_ERROR) && ~isempty(obj.data.data.STAT_PMU_SYNC)
                if ~((obj.data.data.STAT_DATA_ERROR==0 || obj.data.data.STAT_DATA_ERROR==1) && obj.data.data.STAT_PMU_SYNC==0)
                    isValid=false;
                    return
                end
            end
        end

        function UpdateGraph(obj,data,list)
            arguments
                obj PolarPlots
                data PMU
                list
            end
                obj.data=data;
                [mag,ang]=obj.PhasorToMagAndAngle(data);
                switch obj.Mode
                    case ReferenceType.Default
                        if ~isempty(data.data.FREQ)
                            ang=ang+((50-data.data.FREQ)*360);
                        end
                    case ReferenceType.CustomFreq
                        if ~isempty(data.data.FREQ) && ~isempty(obj.Freq)
                            ang=ang+((obj.Freq-data.data.FREQ)*360);
                        end
                    case ReferenceType.OtherPMU

                        if ~isempty(data.data.FREQ) && ~isempty(obj.ID) && isKey(list,obj.ID)
                            OtherDevice=list(obj.ID);
                            if ~isempty(OtherDevice) && ~isempty(OtherDevice.data) && ~isempty(OtherDevice.data.FREQ)
                            ang=ang+((OtherDevice.data.FREQ-data.data.FREQ)*360);
                            end
                        end
                end
                obj.HandleToPlot.UpdatePolarPlot(mag,ang);

                obj.IsValid=obj.CheckQuality();
                obj.HandleToPlot.UpdateTimeQuality(obj.IsValid);
        end

        function delete(obj)
            delete(obj.HandleToPlot);
        end
    end
end