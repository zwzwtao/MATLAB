function Tave = sim_ps_func(n,Tend)

% n represents the number of servers

%rand_setting_1_3 = rng;
%save rand_setting_1_3
                            
%load rand_setting
%rng(rand_setting_1_3) 
%rng(1);
T = 0; % T is the cumulative response time 
N = 0; % number of completed jobs at the end of the simulation
P = 2000; % power budget is 2000 Watts
%avg = []; % average response time for each n jobs

p = P/n;
f = 1.25 + 0.31 * (p/200 - 1);    % f represents frequency
next_arrival_time = exprnd(1/7.2) * (rand(1)*(1.17-0.75)+0.75);
next_departure_time = Inf; 

alpha1 = 0.43;
alpha2 = 0.98;
beta = 0.86;
gamma = (1-beta)/(alpha2^(1-beta) - alpha1^(1-beta));
service_time_next_arrival = ((rand(1)*(1-beta)/gamma + alpha1^(1-beta))^(1/(1-beta))) / f;

master_clock = 0;
job_list = [];  % stores all the jobs and its remaining servicetime in the server
previous_event_time = 0;

while(master_clock < Tend)
    if (next_arrival_time < next_departure_time)
        next_event_time = next_arrival_time;
        next_event_type = 1;    % an arrival
    else % when an arrival and a departure occurs at the same time,always deal with departure first
        next_event_time = next_departure_time;
        next_event_type = 0;    % a departure
    end   
    
    master_clock = next_event_time;
    if(next_event_type == 1) % an arrival
        if(isempty(job_list))  % no job in the server
            job_list = [job_list ; master_clock service_time_next_arrival];
            
            next_departure_time = master_clock + service_time_next_arrival;  
        else   % at least one job in the server
            atu = (master_clock - previous_event_time) / size(job_list, 1); % average time unit the job receives
            for i = 1 : size(job_list, 1)
                job_list(i,2) =  job_list(i,2) - atu;   % update the remaining service time of the jobs
            end
            job_list = [job_list ; master_clock service_time_next_arrival];
            next_departure_time = master_clock + min(job_list(:,2)) * size(job_list, 1);  % update next departure time
        end
        
        next_arrival_time = master_clock ;
        for i = 1 : n
           next_arrival_time = next_arrival_time + (exprnd(1/7.2) * (rand(1)*(1.17-0.75)+0.75));
        end
        
        service_time_next_arrival = ((rand(1)*(1-beta)/gamma + alpha1^(1-beta))^(1/(1-beta))) / f;
        
        previous_event_time = master_clock;
        
    else  % a departure
        sizej = size(job_list,1);
        
       
        c_mini = min(job_list(:,2));
        mini = c_mini;
        while(~isempty(job_list) && min(job_list(:,2)) == mini)
            for i = 1 : size(job_list,1)
                if job_list(i,2) == mini
                    N = N + 1;
                    if N > 1000     % remove transient part
                        T = T + master_clock - job_list(i,1);
                        %avg =[avg ; T / N];
                        % the code above is used to generate data1.mat
                    end
                    job_list(i,:) = [];
                    break;
                end
            end  
        end
        atu = (master_clock - previous_event_time) / sizej;
        for i = 1 : size(job_list, 1)
            job_list(i,2) =  job_list(i,2) - atu;   % update the remaining service time of the jobs
        end
        if(isempty(job_list))  % after this departure,no more jobs in the server
            next_departure_time = Inf;
        else
            next_departure_time = master_clock + min(job_list(:,2)) * size(job_list, 1);  
        end
        
        previous_event_time = master_clock;
        
    end
    
    
end    
    
Tave = T/(N-1000);

%save('data1','avg');             
% the code above with the code in line 76 is used to generater response time of different
% number of jobs  and put the data in data1.mat
end

