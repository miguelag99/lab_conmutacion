clc; clear;

global now FES maxEvent eventTime eventType eventNext 
global eventIsFree slotFreeFlag slotBusyFlag

maxEvent = 100;
eventTime = 1;
eventType = 2;
eventNext = 3;
eventIsFree = 4;

slotBusyFlag = 0;
slotFreeFlag = 1;

eStart = 1;
eStop = 2;

FES = zeros(maxEvent,4);
FES(:,1) = inf;
FES(:,2) = 0;
FES(:,3) = 0;
FES(:,4) = 1;

now = -1;
currentEvent = 0;
simulationTime = 1000;

FES(1,:) = [0 eStart 0 slotBusyFlag];
currentEvent = 1;

FES(2,:) = [simulationTime eStop 0 slotBusyFlag];
FES(currentEvent,eventNext) = 2;

scheduler(4,eStop);

while true
    disp(FES(currentEvent,eventType))
    prev_event = currentEvent;
    switch FES(currentEvent,eventType)
        case eStart
            now = 0;
            currentEvent = FES(currentEvent,eventNext);
            FES(prev_event,:) = [inf 0 0 slotFreeFlag];
            disp("Simulation started");
        case eStop
            % Si se resta del now anterior se obtiene el paso de tiempo
            now = FES(currentEvent,eventTime);
            disp("Simulation finished");
            return;
        otherwise
            disp("Event type not defined");
            return;
    end
end



