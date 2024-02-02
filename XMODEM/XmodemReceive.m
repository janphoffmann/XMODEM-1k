%clear variable inChar packet no Data
function XmodemReceive(device,file)
    t=device;
    no=0;
    flush(t);
    for i=1:50
    
        write(t,'C','char');
        
        for k=1:100
            pause(0.01);
            no=t.NumBytesAvailable;
            if no>0
                break
            end
        end
        if no>0
            break;
        else
            pause(1);
        end
    end
    no=t.NumBytesAvailable;
    oneK=read(t,1);
    
    i=1;
    PL=128;
    while no>0
       
        if i>1
            inChar=read(t,1);
            if inChar==4
                write(t,6,"uint8");
                break;
    
            end
    
        end
        packNo=read(t,1);
        packNoRev=255-read(t,1);
        if packNo-packNoRev ~= 0
            break
        end
        if oneK==1 %==128Byte
            PL=128;
        else
            PL=1024;
        end
        for j=1:PL
            inChar=read(t,1);
            if inChar~=26
                Data(packNo,j)=inChar;
            end
            packet(i,j)=inChar;
        end
        crc(1,1:2)=dec2hex(read(t,1));
        crc(1,3:4)=dec2hex(read(t,1));
        crc=strcat(crc(1,1),crc(1,2),crc(1,3),crc(1,4));
        [ccc,hex]=crc16(packet(i,1:end));
        if hex==crc
            write(t,6,"uint8");
        else 
            write(t,21,"uint8");
        end
        i=i+1;
        pause(0.01);
        no=t.NumBytesAvailable;
    end
    
    for l=1:i-1
        for m=1:PL
            f=fopen(file,"w");
            fwrite(f,Data(l,m));
            fclose(f);
        end
    end
end