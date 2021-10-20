function scheduler(insEvent_time,insEvent_type)
    
    global FES eventTime eventNext 
    global eventIsFree slotBusyFlag
    
    index = find(FES(:,eventIsFree),1,'first');
    
    prev_events_index = find(FES(:,eventTime) < insEvent_time);
    [E,I] = max(FES(prev_events_index,eventTime));
    iEarlier = prev_events_index(I);
    iNext = FES(iEarlier,eventNext);
    
    FES(index,:) = [insEvent_time,insEvent_type,iNext,slotBusyFlag];
    FES(iEarlier,eventNext) = index;

end