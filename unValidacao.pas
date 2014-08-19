unit unValidacao;

interface
  function cpfValido(cpf: String): Boolean; stdcall;
  function cnpjValido(cnpj: String): Boolean; stdcall;
  function inscEstValido(inscEst, uf: String): Boolean; stdcall;
  function validaInscEstAC(inscEst: String): Boolean;
  function validaInscEstAL(inscEst: String): Boolean;
  function validaInscEstAP(inscEst: String): Boolean;
  function validaInscEstAM(inscEst: String): Boolean;
  function validaInscEstBA(inscEst: String): Boolean;
  function validaInscEstDF(inscEst: String): Boolean;
  function validaInscEstGO(inscEst: String): Boolean;
  function validaCartaoCredito(cn: String): ShortInt; stdCall;
  function retornaIssuer(cn: String): ShortInt;

implementation

uses
  SysUtils;

function cpfValido(cpf: String): Boolean;
var
  I, J, K, Sum: Integer;
begin
  if(Length(cpf) <> 11) then
    Result := False
  else
    try
      // Iteração do dígito correspontente
      for K := 0 to 1 do
      begin
        Sum := 0; // Soma para o cálculo do dígito
        J := 9 + K; // Posição no cpf para retirar o algarismo para adicionar
        for I := 2 to (10 + K) do // Itera sobre os pesos
        begin
          Sum := Sum + (I * StrToInt(cpf[J])); // Realiza a multiplicação
          dec(j); // Decrementa a posição
        end;
        Sum := 11 - (Sum mod 11); // Calcula o módulo

        if(Sum > 9) then // Se for maior que 9 vira 0
          Sum := 0;

        // Se o dígito calculado for diferente do original, levanta uma exceção
        if (cpf[10 + K] <> IntToStr(Sum)) then
          raise Exception.Create('');
      end;

      Result := True;
    except
      Result := False;
    end;
end;

function cnpjValido(cnpj: String): Boolean;
var
  I, J, K, Sum: Integer;
begin
  if(Length(cnpj) <> 14) then
    Result := False
  else
    try
      // Iteração do dígito correspontente
      for K := 0 to 1 do
      begin
        Sum := 0; // Soma para o cálculo do dígito
        J := 2; // Guarda o multiplicador
        for I := 12 + K downto 1 do // Itera sobre as posições do cnpj inversamente
        begin
          Sum := Sum + (J * StrToInt(cnpj[I])); // Realiza a multiplicação
          inc(j); // Incrementa o multiplicador

          if(j > 9) then
            j := 2; // Se for maior que 9, reseta novamente para 2
        end;
        Sum := 11 - (Sum mod 11); // Calcula o dígito verificador

        if(Sum > 9) then
          Sum := 0; // Se for maoir que nove, volta para o 0

        // Se o dígito verificador for diferente, levanta uma exceção
        if (cnpj[13 + K] <> IntToStr(Sum)) then
          raise Exception.Create('Dígito verificador inválido');
      end;

      Result := True;
    except
      Result := False;
    end;
end;

function validaInscEstAC(inscEst: String): Boolean;
var
  I, J, K, Sum: Integer;
begin
  if((Length(inscEst) <> 13) OR NOT ((inscEst[1] = '0') AND (inscEst[2] = '1'))) then
    Result := False
  else
    try
      // Iteração do dígito correspontente
      for K := 0 to 1 do
      begin
        Sum := 0; // Soma para o cálculo do dígito
        J := 2; // Guarda o multiplicador
        for I := 11 + K downto 1 do // Itera sobre as posições do inscEst inversamente
        begin
          Sum := Sum + (J * StrToInt(inscEst[I])); // Realiza a multiplicação
          inc(j); // Incrementa o multiplicador

          if(j > 9) then
            j := 2; // Se for maior que 9, reseta novamente para 2
        end;
        Sum := 11 - (Sum mod 11); // Calcula o dígito verificador

        if(Sum > 9) then
          Sum := 0; // Se for maoir que nove, volta para o 0

        // Se o dígito verificador for diferente, levanta uma exceção
        if (inscEst[12 + K] <> IntToStr(Sum)) then
          raise Exception.Create('Dígito verificador inválido');
      end;

      Result := True;
    except
      Result := False;
    end;
end;

function validaInscEstAL(inscEst: String): Boolean;
var
  I, Sum: Integer;
begin
  if((Length(inscEst) <> 9) OR NOT ((inscEst[1] = '2') AND (inscEst[2] = '4'))
    AND NOT ((inscEst[3] = '0') OR (inscEst[3] = '3') OR (inscEst[3] = '5')
    OR (inscEst[3] = '7') OR (inscEst[3] = '8'))) then
    Result := False
  else
    try
      Sum := 0;
      for I := 1 to 8 do
        Sum := Sum + (10 - I) * StrToInt(inscEst[I]);

      Sum := (Sum * 10) - ((Sum * 10) div 11) * 11;

      if(Sum > 9) then
        Sum := 0;

      Result := NOT (inscEst[9] <> IntToStr(Sum));
    except
      Result := False;
    end;
end;

function validaInscEstAM(inscEst: String): Boolean;
var
  I, Sum: Integer;
begin
  if (Length(inscEst) <> 9) then
    Result := False
  else
    try
      Sum := 0;
      for I := 1 to 8 do
      begin
        Sum := Sum + ((10 - I) * StrToInt(inscEst[I]));
      end;

      if Sum < 11 then
        Sum := 11 - Sum
      else
        begin
          Sum := Sum mod 11;
          if Sum < 2 then
            Sum := 0
          else
            Sum := 11 - Sum;
        end;

      Result := (inscEst[9] = IntToStr(Sum));
    except
      Result := False;
    end;
end;

function validaInscEstAP(inscEst: String): Boolean;
var
  I, J, P, D, Sum: Integer;
begin
  if((Length(inscEst) <> 9) OR NOT ((inscEst[1] = '0') AND (inscEst[2] = '3'))) then
    Result := False
  else
    try
      Sum := StrToInt(Copy(inscEst, 1, 8));
      if((Sum > 03000000) AND (Sum < 03017001)) then
        begin
          P := 5;
          D := 0;
        end
      else
        if ((Sum >= 03017001) AND (Sum < 03019023)) then
          begin
            P := 9;
            D := 1;
          end
        else
          if (Sum >= 03019023) then
            begin
              P := 0;
              D := 0;
            end
          else
            raise Exception.Create('Número inválido');

      Sum := 0;
      J := 9;
      for I := 1 to 8 do
      begin
        Sum := Sum + (J * StrToInt(inscEst[I]));
        dec(J);
      end;
      inc(Sum, P);
      Sum := 11 - (Sum mod 11);

      if(Sum = 10) then
        Sum := 0
      else
        if(Sum = 11) then
          Sum := D;

      Result := NOT (inscEst[9] <> IntToStr(Sum));
    except
      Result := False;
    end;
end;

function validaInscEstBA(inscEst: String): Boolean;
var
  J, Sum, Modulo: Integer;
  I: Char;
begin
  if((Length(inscEst) < 8) OR (Length(inscEst) > 9)) then
    Result := False
  else
    try
      if(Length(inscEst) = 8) then
        begin
          case StrToInt(inscEst[1]) of
            0..5,8: Modulo := 10;
            6,7,9: Modulo := 11;
            else
              raise Exception.Create('Erro desconhecido');
          end;

          Sum := 0;
          for J := 1 to 6 do
            Sum := Sum + (8 - J) * StrToInt(inscEst[J]);

          Sum := Modulo - (Sum mod Modulo);

          Result := NOT (((Sum = 0) AND (inscEst[7] <> '0') AND (inscEst[8] = '0')) OR
              (inscEst[8] <> IntToStr(Sum)));

          if(Result) then
          begin
            I := inscEst[7];
            inscEst[7] := inscEst[8];

            Sum := 0;
            for J := 1 to 7 do
              Sum := Sum + (9 - J) * StrToInt(inscEst[J]);

            Sum := Modulo - (Sum mod Modulo);

            Result := (IntToStr(Sum) = I);
          end;
        end
      else
        begin
          case StrToInt(inscEst[2]) of
            0..5,8: Modulo := 10;
            6,7,9: Modulo := 11;
            else
              raise Exception.Create('Erro desconhecido');
          end;

          Sum := 0;
          for J := 1 to 7 do
            Sum := Sum + (9 - J) * StrToInt(inscEst[J]);

          Sum := Modulo - (Sum mod Modulo);

          Result := NOT (((Sum = 0) AND (inscEst[8] <> '0') AND (inscEst[9] = '0')) OR
              (inscEst[9] <> IntToStr(Sum)));

          if(Result) then
          begin
            I := inscEst[8];
            inscEst[8] := inscEst[9];

            Sum := 0;
            for J := 1 to 8 do
              Sum := Sum + (10 - J) * StrToInt(inscEst[J]);

            Sum := Modulo - (Sum mod Modulo);

            if(Sum = 1) then Sum := 0;

            Result := (IntToStr(Sum) = I);
          end;
        end;
    except
      Result := False;
    end;
end;

function validaInscEstDF(inscEst: String): Boolean;
var
  I, J, K, Sum: Integer;
begin
  if(Length(inscEst) <> 13) OR NOT ((inscEst[1] = '0') AND (inscEst[2] = '7')) then
    Result := False
  else
    try

      for K := 0 to 1 do
      begin

        Sum := 0;
        J := 2;
        for I := (11 + K) downto 1 do
        begin
          Sum := Sum + (J * StrToInt(inscEst[I]));

          inc(J);
          if(j > 9) then
            j := 2;
        end;

        Sum := 11 - (Sum mod 11);

        if(Sum > 9) then
          Sum := 0;

        if(inscEst[12 + K] <> IntToStr(Sum)) then
          raise Exception.Create('Número inválido');

      end;

      Result := True;
    except
      Result := False;
    end;
end;

function validaInscEstGO(inscEst: String): Boolean;
var
  I, Sum: Integer;
begin
  if (Length(inscEst) <> 9) OR NOT (
    (inscEst[1] = '1') AND (
      (inscEst[2] = '0') OR (inscEst[2] = '1') OR (inscEst[2] = '5')
    )) then
    Result := False
  else
    try

      if(Copy(inscEst, 1, 8) = '11094402') then
        Result := (inscEst[9] = '1') OR (inscEst[9] = '0')
      else
        begin
          Sum := 0;
          for I := 1 to 8 do
            Sum := Sum + ((10 - I) * StrToInt(inscEst[I]));

          if Sum < 11 then
            Sum := 11 - Sum
          else
            begin
              Sum := Sum mod 11;
              if(Sum = 0) then
                Sum := 0
              else
                if (Sum = 1) AND (StrToInt(Copy(inscEst, 1, 8)) >= 10103105)
                  AND (StrToInt(Copy(inscEst, 1, 8)) <= 10119997) then
                  Sum := 1
                else
                  if (Sum = 1) then
                    Sum := 0
                  else
                    Sum := 11 - Sum;
            end;

          Result := (inscEst[9] = IntToStr(Sum));
        end;
    except
      Result := False;
    end;
end;

function inscEstValido(inscEst, uf: String): Boolean;
begin
  if(uf = 'AC') then
    Result := validaInscEstAC(inscEst)
  else
    if(uf = 'AL') then
      Result := validaInscEstAL(inscEst)
    else
      if(uf = 'AP') then
        Result := validaInscEstAP(inscEst)
      else
        if(uf = 'AM') OR (uf = 'CE') OR (uf = 'ES') then
          Result := validaInscEstAM(inscEst)
        else
          if(uf = 'BA') then
            Result := validaInscEstBA(inscEst)
          else
            if (uf = 'DF') then
              Result := validaInscEstDF(inscEst)
            else
              if(uf = 'GO') then
                Result := validaInscEstGO(inscEst)
              else
                Result := False;
end;

function retornaIssuer(cn: String): ShortInt;
begin
  if(cn[1] = '4') then // Visa
    Result := 0
  else
    if(cn[1] = '5') then // Master Card
      Result := 1
    else
      if(cn[1] = '3') AND ((cn[2] = '4') OR (cn[2] = '7')) then // American Express
        Result := 2
      else
        Result := 3; // Outros
end;

function validaCartaoCredito(cn: String): ShortInt;
var
  i, j, Sum : Integer;
begin
  if (Length(cn) > 20) OR (Length(cn) < 13) then
    Result := -1
  else
    try
      Sum := 0;

      for i := (Length(cn) - 1) downto 1 do
      begin
        j := Length(cn) - i;

        if((j mod 2) = 0) then
          inc(sum, StrToInt(cn[i]))
        else
          begin
            J := StrToInt(cn[i]) * 2;

            if(J > 9) then
              inc(sum, StrToInt(IntToStr(J)[1]) + StrToInt(IntToStr(J)[2]))
            else
              inc(sum, J);
          end;
      end;

      Sum := (10 - (Sum mod 10));

      if(Sum = 10) then
        sum := 0;

      if(Sum = StrToInt(cn[Length(cn)])) then
        Result := retornaIssuer(cn)
      else
        Result := -1;
    except
      Result := -1;
    end;
end;

end.
