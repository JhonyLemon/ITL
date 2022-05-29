classdef PolarPlots < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties(Access=public)
        HandleToPlot;
        Mode ReferenceType=ReferenceType.None;
        ExtraAngle=0
        IsValid=true;
        data PMU
        mag
        ang
        ID
        STN
        index=0
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
                k=keys(data.data.PHASORS0);
                mag=data.data.PHASORS0(char(obj.HandleToPlot.STN));
                k=keys(mag);
                
                mag=mag(char(cell2mat(k(1))));
                ang=data.data.PHASORS1(char(obj.HandleToPlot.STN));
                k=keys(ang);
                ang=ang(char(cell2mat(k(1))));
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
            if ~isempty(obj.data.data) && ~isempty(obj.data.data.STAT_DATA_ERROR) && ~isempty(obj.data.data.STAT_PMU_SYNC) && obj.index~=0
                if ~((obj.data.data.STAT_DATA_ERROR(obj.HandleToPlot.STN)==0 || obj.data.data.STAT_DATA_ERROR(obj.HandleToPlot.STN)==1) && obj.data.data.STAT_PMU_SYNC(obj.HandleToPlot.STN)==0)
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
                            if ~isempty(data.data.FREQ(obj.HandleToPlot.STN))
                                ang=deg2rad(((50-data.data.FREQ(obj.HandleToPlot.STN))*360));
                            end
                        case ReferenceType.CustomFreq
                            if ~isempty(data.data.FREQ(obj.HandleToPlot.STN)) && ~isempty(obj.Freq)
                                ang=deg2rad(((obj.Freq-data.data.FREQ(obj.HandleToPlot.STN))*360));
                            end
                        case ReferenceType.OtherPMU
    
                            if ~isempty(data.data.FREQ(obj.HandleToPlot.STN)) && ~isempty(obj.ID) && isKey(list,obj.ID) && ~isempty(obj.STN)
                                OtherDevice=list(obj.ID);
                                k=keys(OtherDevice);
                                key=char(cell2mat(k(1)));
                                Device=OtherDevice(key);
                                if ~isempty(Device.data) && ~isempty(Device.data.data) && ~isempty(Device.data.data.FREQ)
                                ang=deg2rad(((Device.data.data.FREQ(key)-data.data.FREQ(obj.HandleToPlot.STN))*360));
                                end
                            end
                    end
                    obj.mag=mag;
                    obj.ang=ang;
                    obj.HandleToPlot.UpdatePolarPlot(mag,ang);

                    obj.IsValid=obj.CheckQuality();
                    obj.HandleToPlot.UpdateTimeQuality(obj.IsValid);
        end

        function delete(obj)
            delete(obj.HandleToPlot);
        end
    end
end