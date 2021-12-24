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

simulationTime = 1000;


eStart = 1;
eStop = 2;
eArrival = 3;
eDeparture = 4;

lambda = 2;
mu = 6;

serverUsed = 0;
numberInQueue = 0;

T = 5*simulationTime*lambda;
statServerUse = (-1)*ones(T,2);
statQueueLength = (-1)*ones(T,2);
total_users = (-1)*ones(T,2);
mean_users = (-1)*ones(T,2);

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
            now = FES(currentEvent,eventTime);
            statQueueLength(find(statQueueLength(:,1) == -1,1,'first'),:) = [now numberInQueue];  
            statServerUse(find(statServerUse(:,1) == -1,1,'first'),:) = [now serverUsed];
            total_users(find(total_users(:,1) == -1,1,'first'),:) = [now numberInQueue+serverUsed];
            new_mean = avg_users(total_users);
            mean_users(find(mean_users(:,1) == -1,1,'first'),:) = [now new_mean];
            
            disp("Simulation finished");
            
            
            figure('Name','Queue length')
            statQueueLength = vertcat([0,0],statQueueLength);
            aux = find(statQueueLength(:,1) == -1,1,'first') - 1;
            stairs(statQueueLength(1:aux,1),statQueueLength(1:aux,2))
            ylim([-0.2 inf])
            title('Queue length')
            
            figure('Name','Server Use')
            aux = find(statServerUse(:,1) == -1,1,'first') - 1;
            stairs(statServerUse(1:aux,1),statServerUse(1:aux,2))
            ylim([-0.2 1.2])
            title('Server Use')
            
            figure('Name','Total and mean system users')
            aux = find(total_users(:,1) == -1,1,'first') - 1;
            stairs(total_users(1:aux,1),total_users(1:aux,2))
            hold on
            aux = find(mean_users(:,1) == -1,1,'first') - 1;
            plot(mean_users(1:aux,1),mean_users(1:aux,2),'r')
            title('Total users')
            legend('Total users in the system','Mean users')
            
            return;
            
        case eArrival
            
            statQueueLength(find(statQueueLength(:,1) == -1,1,'first'),:) = [now numberInQueue];  
            statServerUse(find(statServerUse(:,1) == -1,1,'first'),:) = [now serverUsed];
            total_users(find(total_users(:,1) == -1,1,'first'),:) = [now numberInQueue+serverUsed];
            new_mean = avg_users(total_users);
            mean_users(find(mean_users(:,1) == -1,1,'first'),:) = [now new_mean];    
            
            now = FES(currentEvent,eventTime);
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
            
            statQueueLength(find(statQueueLength(:,1) == -1,1,'first'),:) = [now numberInQueue];  
            statServerUse(find(statServerUse(:,1) == -1,1,'first'),:) = [now serverUsed];
            total_users(find(total_users(:,1) == -1,1,'first'),:) = [now numberInQueue+serverUsed];
            new_mean = avg_users(total_users);
            mean_users(find(mean_users(:,1) == -1,1,'first'),:) = [now new_mean];
            
            now = FES(currentEvent,eventTime);
            
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

