function [crc, hex] = XmodemCRC16(packet)
crc = 0;
for i = 1:length(packet)
    crc = bitxor( crc, bitshift(packet(i),8) );
    for bit = 1:8
        if bitand( crc, hex2dec('8000') )     % if MSB=1
          crc = bitxor( bitshift(crc,1), hex2dec('1021') );
        else
          crc = bitshift(crc,1);
        end
        crc = bitand( crc, hex2dec('ffff') );  % trim to 16 bits
    end
end
hex = dec2hex(crc);
