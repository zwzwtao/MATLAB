T = [   1.0242	0.6247	0.5433	0.5212	0.5139	0.5236	0.5308	0.5430
   1.0049	0.6171	0.5359	0.5195	0.5147	0.5206	0.5294	0.5432
   1.0324	0.6416	0.5418	0.5166	0.5196	0.5228	0.5366	0.5433
   0.9506	0.6303	0.5349	0.5161	0.5165	0.5177	0.5304	0.5416
   1.0404	0.6304	0.5394	0.5193	0.5142	0.5253	0.5322	0.5434 ];

dt = ones(5 ,8);

% Compute the following differenes


for i = 1 : size(T,2) - 1
    for j = i+1 : size(T,2) 
        eval(['dt',num2str(i+2),num2str(j+2),'=','T(:,i) - T(:,j);']);
    end
end

% multiplier for confidence interval
mf = tinv(0.975,4)/sqrt(5);
for i = 1 : size(T,2) - 1
    for j = i+1 : size(T,2) 
        
        eval(['confi_inter',num2str(i+2),num2str(j+2),'= mean(dt',num2str(i+2),num2str(j+2),')+','[-1 1] * std(dt',num2str(i+2),num2str(j+2), ')*mf']);
    end
end


