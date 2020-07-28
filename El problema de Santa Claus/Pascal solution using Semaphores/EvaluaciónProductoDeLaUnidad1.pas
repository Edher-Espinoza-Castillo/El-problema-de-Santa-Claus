program SantaClaussem;
const TotalRenos=7;NumDuendesGrupo=3;
var SantaSem,DuendesSem,RenosSem,mutex:semaphore;
renos,duendes:integer;

process SantaClaus;
begin
      repeat
           wait(SantaSem);
           wait(mutex);
           if (renos=TotalRenos) then
           begin
                         signal(RenosSem);
                         writeln('santa salio a repartir regalos');
                   writeln(' ');
                   signal(mutex);
                   end
           else
         begin
                 if (duendes = NumDuendesGrupo) then
                   begin
                        writeln(' Santa ayuda a los Duendes...');
                               signal(DuendesSem);
                        signal(mutex);
                   end
           end;
      forever
end;

process Reno;
begin
      repeat
      wait(mutex);
      if (renos=TotalRenos-1) then
      begin
           renos:=renos+1;
           signal(SantaSem);
           writeln('reno ',renos,' llegó de vacaciones y despertó a santa...');
           signal(mutex);
           wait(RenosSem);
           renos:=0;
      end
      else

      begin
           renos:=renos+1;
           writeln('reno ',renos,' llegó de vacaciones');
           signal(mutex);
      end;
      forever
end;

process Duende;
begin
      repeat
      wait(mutex);
      if ((duendes = NumDuendesGrupo-1)) then
      begin
            duendes:=duendes+1;
            writeln(' tres duendes despiertan a santa solo a pedir ayuda');
            signal(SantaSem);
            signal(mutex);
            wait(DuendesSem);
            duendes:=0;
      end
      else
      begin
            duendes:=duendes+1;
            signal(mutex);
      end;
      forever
end;

begin
duendes:=0;
renos:=0;
initial(mutex,1);
initial(SantaSem,0);
initial(RenosSem,0);
initial(DuendesSem,0);
cobegin
      SantaClaus;
      Reno;
      Duende;
coend;
end.