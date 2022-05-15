function UpdateData(app,pmu)
%Used to update data on DeviceDetailsDialog
arguments
    app DeviceDetailsDialog
    pmu
end
    pmu=pmu(uint32(app.ID));
    app.index=0;
    if pmu.cnf_version~=0
        if pmu.cnf_version==1 || pmu.cnf_version==2
            [n,~]=size(pmu.cnf.STN);
            for i=1:n
                if strcmp(strip(replace(string(pmu.cnf.STN(i,:)),char(0x00),' ')),app.STN)
                    app.index=i;
                    break;
                end
            end
        elseif pmu.cnf_version==3
            [~,n]=size(pmu.cnf3.STN);
            for i=1:n
                if strcmp(strip(replace(string(pmu.cnf3.STN(i,:)),char(0x00),' ')),app.STN)
                    app.index=i;
                    break;
                end
            end
        end
    end
    if app.index~=0
        if ~isempty(pmu.data)
            if ~isempty(pmu.data.SYNCVERSION)
            app.SYNCVERSION.Text=string(pmu.data.SYNCVERSION);
            end
            if ~isempty(pmu.data.FRAMESIZE)
            app.FRAMESIZE.Text=string(pmu.data.FRAMESIZE);
            end
            if ~isempty(pmu.data.ID_CODE_SOURCE)
            app.ID_CODE_SOURCE.Text=string(pmu.data.ID_CODE_SOURCE);
            end
            if ~isempty(pmu.data.SOC)
            app.SOC.Text=string(pmu.data.SOC);
            end
            if ~isempty(pmu.data.MTQ_L_S_DIRECTION)
            app.MTQ_L_S_DIRECTION.Text=string(pmu.data.MTQ_L_S_DIRECTION);
            end
            if ~isempty(pmu.data.MTQ_L_S_OCCURRED)
            app.MTQ_L_S_OCCURRED.Text=string(pmu.data.MTQ_L_S_OCCURRED);
            end
            if ~isempty(pmu.data.MTQ_L_S_PENDING)
            app.MTQ_L_S_PENDING.Text=string(pmu.data.MTQ_L_S_PENDING);
            end
            if ~isempty(pmu.data.MTQ_L_S_INDICATOR)
            app.MTQ_L_S_INDICATOR.Text=string(pmu.data.MTQ_L_S_INDICATOR);
            end
            if ~isempty(pmu.data.STAT_DATA_ERROR)
                app.STAT_DATA_ERROR.Text=string(pmu.data.STAT_DATA_ERROR(app.STN));
            end
            if ~isempty(pmu.data.STAT_PMU_SYNC)
                app.STAT_PMU_SYNC.Text=string(pmu.data.STAT_PMU_SYNC(app.STN));
            end
            if ~isempty(pmu.data.STAT_DATA_SORTING)
                app.STAT_DATA_SORTING.Text=string(pmu.data.STAT_DATA_SORTING(app.STN));
            end
            if ~isempty(pmu.data.STAT_PMU_TRIGGER)
                app.STAT_PMU_TRIGGER.Text=string(pmu.data.STAT_PMU_TRIGGER(app.STN));
            end
            if ~isempty(pmu.data.STAT_CNF_CHANGE)
                app.STAT_CNF_CHANGE.Text=string(pmu.data.STAT_CNF_CHANGE(app.STN));
            end
            if ~isempty(pmu.data.STAT_DATA_MODIFIED)
                app.STAT_DATA_MODIFIED.Text=string(pmu.data.STAT_DATA_MODIFIED(app.STN));
            end
            if ~isempty(pmu.data.STAT_PMU_TQ)
                app.STAT_PMU_TQ.Text=string(pmu.data.STAT_PMU_TQ(app.STN));
            end
            if ~isempty(pmu.data.STAT_UNLOCKED_TIME)
            app.STAT_UNLOCKED_TIME.Text=string(pmu.data.STAT_UNLOCKED_TIME(app.STN));
            end
            if ~isempty(pmu.data.STAT_TRIGGER_REASON)
                app.STAT_TRIGGER_REASON.Text=string(pmu.data.STAT_TRIGGER_REASON(app.STN));
            end
            if ~isempty(pmu.data.PHASORS0)
                handleToMap=pmu.data.PHASORS0(app.STN);
                text="";
                k=keys(handleToMap);
                [n,m]=size(k);
                for i=1:m
                    key=char(cell2mat(k(i)));
                    text=text+" "+string(handleToMap(key));
                end
                app.PHASORS0.Text=text;
            end
            if ~isempty(pmu.data.PHASORS1)
                handleToMap=pmu.data.PHASORS1(app.STN);
                text="";
                k=keys(handleToMap);
                [n,m]=size(k);
                for i=1:m
                    key=char(cell2mat(k(i)));
                    text=text+" "+string(handleToMap(key));
                end
                app.PHASORS1.Text=text;
            end
            if ~isempty(pmu.data.FREQ)
                app.FREQ.Text=string(pmu.data.FREQ(app.STN));
            end
            if ~isempty(pmu.data.DFREQ)
                app.DFREQ.Text=string(pmu.data.DFREQ(app.STN));
            end
            if ~isempty(pmu.data.ANALOG)
                handleToMap=pmu.data.ANALOG(app.STN);
                text="";
                k=keys(handleToMap);
                [n,m]=size(k);
                for i=1:m
                    key=char(cell2mat(k(i)));
                    text=text+" "+string(handleToMap(key));
                end
                app.ANALOG.Text=text;
            end
            if ~isempty(pmu.data.DIGITAL)
                handleToMap=pmu.data.DIGITAL(app.STN);
                text="";
                k=keys(handleToMap);
                [n,m]=size(k);
                for i=1:m
                    key=char(cell2mat(k(i)));
                    text=text+" "+string(handleToMap(key));
                end
                app.DIGITAL.Text=text;
            end
            if ~isempty(pmu.data.FRACSEC)
            app.FRACSEC.Text=string(pmu.data.FRACSEC);
            end

        end
        if ~isempty(pmu.cnf3)
            
        end
        if ~isempty(pmu.cnf)
            if ~isempty(pmu.cnf.SYNCVERSION)
                app.SYNCVERSION_CNF.Text=string(pmu.cnf.SYNCVERSION);
            end
            if ~isempty(pmu.cnf.FRAMESIZE)
                app.FRAMESIZE_CNF.Text=string(pmu.cnf.FRAMESIZE);
            end
            if ~isempty(pmu.cnf.ID_CODE_SOURCE)
                app.ID_CODE_SOURCE_CNF.Text=string(pmu.cnf.ID_CODE_SOURCE);
            end
            if ~isempty(pmu.cnf.SOC)
                app.SOC_CNF.Text=string(pmu.cnf.SOC);
            end
            if ~isempty(pmu.cnf.MTQ_L_S_DIRECTION)
            app.MTQ_L_S_DIRECTION_CNF.Text=string(pmu.cnf.MTQ_L_S_DIRECTION);
            end
            if ~isempty(pmu.cnf.MTQ_L_S_OCCURRED)
            app.MTQ_L_S_OCCURRED_CNF.Text=string(pmu.cnf.MTQ_L_S_OCCURRED);
            end
            if ~isempty(pmu.cnf.MTQ_L_S_PENDING)
            app.MTQ_L_S_PENDING_CNF.Text=string(pmu.cnf.MTQ_L_S_PENDING);
            end
            if ~isempty(pmu.cnf.MTQ_L_S_INDICATOR)
            app.MTQ_L_S_INDICATOR_CNF.Text=string(pmu.cnf.MTQ_L_S_INDICATOR);
            end
            if ~isempty(pmu.cnf.FRACSEC)
                app.FRACSEC_CNF.Text=GetText(app,pmu.cnf.FRACSEC);
            end
            if ~isempty(pmu.cnf.TIME_BASE_FLAGS)
                app.TIME_BASE_FLAGS_CNF.Text=string(pmu.cnf.TIME_BASE_FLAGS);
            end
            if ~isempty(pmu.cnf.TIME_BASE)
                app.TIME_BASE_CNF.Text=string(pmu.cnf.TIME_BASE);
            end
            if ~isempty(pmu.cnf.NUM_PMU)
                app.NUM_PMU_CNF.Text=string(pmu.cnf.NUM_PMU);
            end
            if ~isempty(pmu.cnf.STN)
                text="";
                text=text+" "+strip(replace(string(pmu.cnf.STN(app.index,:)),char(0x00),' '));
                app.STN_CNF.Text=text;
            end
            if ~isempty(pmu.cnf.ID_CODE_DATA)
                app.ID_CODE_DATA_CNF.Text=GetText(app,pmu.cnf.ID_CODE_DATA);
            end
            if ~isempty(pmu.cnf.FORMAT_FREQ)
                app.FORMAT_FREQ_CNF.Text=GetText(app,pmu.cnf.FORMAT_FREQ);
            end
            if ~isempty(pmu.cnf.FORMAT_ANALOG)
                app.FORMAT_ANALOG_CNF.Text=GetText(app,pmu.cnf.FORMAT_ANALOG);
            end
            if ~isempty(pmu.cnf.FORMAT_PHASORS)
            app.FORMAT_PHASORS_CNF.Text=GetText(app,pmu.cnf.FORMAT_PHASORS);
            end
            if ~isempty(pmu.cnf.FORMAT_FORM)
            app.FORMAT_FORM_CNF.Text=GetText(app,pmu.cnf.FORMAT_FORM);
            end
            if ~isempty(pmu.cnf.PHNMR)
                app.PHNMR_CNF.Text=GetText(app,pmu.cnf.PHNMR);
            end
            if ~isempty(pmu.cnf.ANNMR)
                app.ANNMR_CNF.Text=GetText(app,pmu.cnf.ANNMR);
            end
            if ~isempty(pmu.cnf.DGNMR)
                app.DGNMR_CNF.Text=GetText(app,pmu.cnf.DGNMR);
            end
            if ~isempty(pmu.cnf.CHNAM_PHNMR)
                app.CHNAM_PHNMR_CNF.Text=GetText(app,pmu.cnf.CHNAM_PHNMR);
            end
            if ~isempty(pmu.cnf.CHNAM_ANNMR)
                app.CHNAM_ANNMR_CNF.Text=GetText(app,pmu.cnf.CHNAM_ANNMR);
            end
            if ~isempty(pmu.cnf.CHNAM_DGNMR)
                app.CHNAM_DGNMR_CNF.Text=GetText(app,pmu.cnf.CHNAM_DGNMR);
            end
            if ~isempty(pmu.cnf.DIGUNIT0)
            app.DIGUNIT0_CNF.Text=GetText(app,pmu.cnf.DIGUNIT0);
            end
            if ~isempty(pmu.cnf.DIGUNIT1)
            app.DIGUNIT1_CNF.Text=GetText(app,pmu.cnf.DIGUNIT1);
            end
            if ~isempty(pmu.cnf.FNOM)
            app.FNOM_CNF.Text=GetText(app,pmu.cnf.FNOM);
            end
            if ~isempty(pmu.cnf.CFGCNT)
            app.CFGCNT_CNF.Text=GetText(app,pmu.cnf.CFGCNT);
            end
            if ~isempty(pmu.cnf.DATA_RATE)
            app.DATA_RATE_CNF.Text=GetText(app,pmu.cnf.DATA_RATE);
            end
            if ~isempty(pmu.cnf.PHUNIT_TYPE)
            app.PHUNIT_TYPE_CNF.Text=GetText(app,pmu.cnf.PHUNIT_TYPE);
            end
            if ~isempty(pmu.cnf.PHUNIT)
            app.PHUNIT_CNF.Text=GetText(app,pmu.cnf.PHUNIT);
            end
            if ~isempty(pmu.cnf.ANUNIT_TYPE)
            app.ANUNIT_TYPE_CNF.Text=GetText(app,pmu.cnf.ANUNIT_TYPE);
            end
            if ~isempty(pmu.cnf.ANUNIT)
            app.ANUNIT_CNF.Text=GetText(app,pmu.cnf.ANUNIT);
            end
        end
    end  
end

