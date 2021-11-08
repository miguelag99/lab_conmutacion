clc; clear;

global now FES maxEvent eventTime eventType eventNext 
global eventIsFree slotFreeFlag slotBusyFlag

%% FES construction

maxEvent = 100;
eventTime = 1;
eventType = 2;
eventNext = 3;
eventIsFree = 4;
slotBusyFlag = 0;
slotFreeFlag = 1;

FES = zeros(maxEvent,4);
FES(:,1) = inf;
FES(:,2) = 0;
FES(:,3) = 0;
FES(:,4) = 1;

%% Event types and var declaration

%simulationTime = 1000;
simulationTime = 10;

eStart = 1;
eStop = 2;
eArrival = 3;
eDeparture = 4;

lambda = 0.5;
mu = 6;

serverUsed = 0;
numberInQueue = 0;

T = simulationTime*lambda
statServerUse = (-1)*ones(T,2)
statQueueLength = (-1)*ones(T,2)

%% Simulation context init (start and finish)
now = -1;

FES(1,:) = [0 eStart 0 slotBusyFlag];
currentEvent = 1;

FES(2,:) = [simulationTime eStop 0 slotBusyFlag];
FES(currentEvent,eventNext) = 2;

%% Begin event handling

scheduler(t_arrival(lambda),eArrival); %First arrival

while true
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
        case eArrival
            now = FES(currentEvent,eventTime);
            disp("Legada de un usuario en "+now)
            scheduler(now+t_arrival(lambda),eArrival);
            
            if serverUsed == 0
                serverUsed = 1;
                scheduler(now+t_arrival(mu),eDeparture)
            else
                numberInQueue = numberInQueue + 1;
            end

            currentEvent = FES(currentEvent,eventNext);
            FES(prev_event,:) = [inf 0 0 slotFreeFlag];
        case eDeparture
            now = FES(currentEvent,eventTime);
            disp("Salida de un usuario en "+now)

            if numberInQueue > 0
                numberInQueue = numberInQueue - 1;
                scheduler(now+t_arrival(mu),eDeparture)
            elseif numberInQueue == 0
                serverUsed = 0;
            end

            currentEvent = FES(currentEvent,eventNext);
            FES(prev_event,:) = [inf 0 0 slotFreeFlag];           
        otherwise
            disp("Event type not defined");
            return;
    end
end

