function ok=XmodemTransmit(file,device)
    flush(device);
    file = fopen(file,'r');
    fseek(file, 0, 'eof');
    abs_size=ftell(file);
    frewind(file);
    packetNo=1;
    %
    inChar=0;
    while inChar ~= 67 && inChar ~= 21
        inChar=read(device,1,"uint8");
    end
    NoOfTrys=0;
    while abs_size-ftell(file)>0
        filepos=ftell(file);
        if abs_size-filepos >128
            packetLen=1024;
            write(device,2,"uint8");
        else
            packetLen=128;
            write(device,1,"char");
        end
        %pause(0.01);
        if packetNo ==256
            packetLen=1;
        end
        write(device,packetNo,"char");
        %pause(0.01);
        write(device,255-packetNo,"char");
        %packet(1)=0;
        for i=1:packetLen
            fp=ftell(file);
            if (abs_size-fp) > 0
                inChar=fread(file,1);
            else
                inChar=26;
            end
            packet(i)=(inChar);
        end
        %pause(0.01);
        write(device,packet,"uint8");
        %pause(0.01);
        [ccc,hex]=XmodemCRC16((packet));
        crc=strcat(hex(1,3),hex(1,4),hex(1,1),hex(1,2));
        write(device,hex2dec(crc),"uint16");
        inChar=0;
        while inChar ==0
            pause(0.1)
            no=device.NumBytesAvailable;
            if no>0
                inChar=read(device,1);
            end
            if inChar==21
                inChar=-1;
            end
        end
        
        if(inChar==-1) 
            if NoOfTrys>3
                ok=0;
                break;
            end
            fseek(file,ftell(file),-packetLen);
            NoOfTrys=NoOfTrys+1;
            continue
        end
        packetNo=packetNo+1;

        if abs_size-ftell(file)==0
            write(device,4);
            inChar=0;
            while inChar ==0
                pause(0.1)
                no=device.NumBytesAvailable;
                if no>0
                    inChar=read(device,1);
                end
                if inChar==6
                    ok=1;
                    break;
                elseif inChar==21
                    inChar=-1;
                    ok=0;
                    break;
                end
            end
            if inChar==6
                    ok=1;   
                break;
            end
        end
    end

    
