classdef MessageTimeQuality < uint8
    %Message Time Quality indicator code
   enumeration
      Time15 (15)          %Fault―clock failure, time not reliable
      Time14 (14)          %Time within 10000s of UTC
      Time13 (13)          %Time within 1000s of UTC
      Time12 (12)          %Time within 100s of UTC
      Time11 (11)          %Time within 10s of UTC
      Time10 (10)          %Time within 1s of UTC
      Time9  (9)           %Time within 10–1s of UTC
      Time8  (8)           %Time within 10–2s of UTC
      Time7  (7)           %Time within 10–3s of UTC
      Time6  (6)           %Time within 10–4s of UTC
      Time5  (5)           %Time within 10–5s of UTC
      Time4  (4)           %Time within 10–6s of UTC
      Time3  (3)           %Time within 10–7s of UTC
      Time2  (2)           %Time within 10–8s of UTC
      Time1  (1)           %Time within 10–9s of UTC
      Time0  (0)           %Normal operation, clock locked to UTC traceable source
   end
end

