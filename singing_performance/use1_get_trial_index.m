%% Save indices for listening,singing and baseline trials
i0=1:11:110;
lis=1;
base=1;
singing=1;
i0_count=1;
for i=1:110
    if i==(i0(i0_count))|| i-(i0(i0_count))==3 || i-(i0(i0_count))==6
        listen(lis)=i;
        lis=lis+1;
    elseif i-(i0(i0_count))==9
        baseline(base)=i;
        base=base+1;
    elseif i-(i0(i0_count))==10
        baseline(base)=i;
        base=base+1;
        i0_count=i0_count+1;
    else
        sing(singing)=i;
        singing=singing+1;
    end
end
listen=listen'; listen(:,2)=1:1:30;
baseline=baseline'; baseline(:,2)=1:1:20;
sing=sing';
sing_along=sing(1:2:end); sing_along(:,2)=1:1:30;
sing_memo=sing(2:2:end); sing_memo(:,2)=1:1:30;

save('trial_idx','listen','sing_along','sing_memo','baseline')