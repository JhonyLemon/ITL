classdef DataSorting < uint8
    %Data Sorting Type
    % Data Sorting Type: set to 1 when the data for the particular PMU is not integrated into the data
    % frame by using its time tag. A concentrator will normally integrate data from a number of PMUs into a
    % single frame by the time tags provided by the PMUs. If a PMU in the group loses external time sync for an
    % extended period, a time tag provided by the PMU may prevent this integration, or make time alignment
    % worse than using another integration method. As an alternative to simply discarding all the data, the
    % concentrator can include the data in the frame using a “best guess” as to which frame it goes in, and a
    % warning of lack of precise time correlation by setting bit 12. The simplest approach for the concentrator in a
    % real-time system is to include the unsynchronized data with the most current synchronized data using the
    % assumption that data communication delays are equal. This “sort-by-arrival” method is a simple best guess
    % data alignment. Other methods can be used. In all cases, Bit 12 will be set to 1 when data is not correlated
    % into its frame by time tag and cleared to 0 when data is correlated by time tag.
   enumeration
      ByStamp (0)   %by time stamp, 
      ByArrival (1) %by arrival
   end

end

