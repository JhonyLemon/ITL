function DataBaseWrite(handle,datas)
    
COMMONDATA="CommonData";
COMMONDATAFRAME="CommonDataFrame";
DATAFRAMEANALOGSTN="DataFrameAnalogSTN";
DATAFRAMEPHASORSTN="DataFramePhasorSTN";
DATAFRAMESTN="DataFrameSTN";
     
for i=1:size(datas,2)
    data=datas(i);
    %Writring Common fields
    dat = table(data.FRAMESIZE,data.ID_CODE_SOURCE,data.SOC,data.FRACSEC,string(data.SYNCFRAMETYPE),string(data.SYNCVERSION), ...
        'VariableNames',["FRAMESIZE" "IDCODE" "SOC" "FRACSEC" "SYNCFRAMETYPE" "SYNCVERSION"]);
    handle.sqlwrite(COMMONDATA, dat);



   k=keys(data.STAT_DATA_ERROR);
   for j=1:size(data.STAT_DATA_ERROR)
        key=char(cell2mat(k(j)));

        %Writring Common dataframe fields
        dat = table(data.ID_CODE_SOURCE,data.SOC,string(key),string(data.STAT_DATA_ERROR(key)),string(data.STAT_PMU_SYNC(key)),string(data.STAT_DATA_SORTING(key)),string(data.STAT_PMU_TRIGGER(key)),string(data.STAT_CNF_CHANGE(key)),string(data.STAT_DATA_MODIFIED(key)),string(data.STAT_PMU_TQ(key)),string(data.STAT_UNLOCKED_TIME(key)),string(data.STAT_TRIGGER_REASON(key)), ...
            'VariableNames',["IDCODE" "SOC" "STN" "STAT_DATA_ERROR" "STAT_PMU_SYNC" "STAT_DATA_SORTING" "STAT_PMU_TRIGGER" "STAT_CNF_CHANGE" "STAT_DATA_MODIFIED" "STAT_PMU_TQ" "STAT_UNLOCKED_TIME" "STAT_TRIGGER_REASON"]);
        handle.sqlwrite(COMMONDATAFRAME, dat);
    
    
        %Writring dataframe freq/dfreq fields
        dat = table(data.ID_CODE_SOURCE,data.SOC,string(key),data.FREQ(key),data.DFREQ(key), ...
            'VariableNames',["IDCODE" "SOC" "STN" "FREQ" "DFREQ"]);
        handle.sqlwrite(DATAFRAMESTN, dat);
   

        phasor00=data.PHASORS0(key);
        phasor10=data.PHASORS1(key);
        k1=keys(phasor00);
        for m=1:size(phasor00)
            key1=char(cell2mat(k1(m)));
            phasor0=phasor00(key1);
            phasor1=phasor10(key1);
                %Writring dataframe phasors fields
                dat = table(data.ID_CODE_SOURCE,data.SOC,string(key),string(key1),phasor0,phasor1, ...
                    'VariableNames',["IDCODE" "SOC" "STN" "PHASOR_NAME" "MAGNITUDE" "PHASE"]);
                handle.sqlwrite(DATAFRAMEPHASORSTN, dat);
        end

            analog=data.ANALOG(key);
            k1=keys(analog);
        for m=1:size(analog)
            key1=char(cell2mat(k1(m)));
            analog0=analog(key1);
                %Writring dataframe analog fields
                dat = table(data.ID_CODE_SOURCE,data.SOC,string(key),string(key1),analog0, ...
                    'VariableNames',["IDCODE" "SOC" "STN" "ANALOG_NAME" "ANALOG"]);
                handle.sqlwrite(DATAFRAMEANALOGSTN, dat);
        end

   end
end
commit(handle);
end

