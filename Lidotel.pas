program Lidotel;
{$codepage UTF8} //Permite usar acentos y ñ en consola.

{Integrantes del grupo:
Jose Ferreira V28315655
Adriano Robati V}

uses crt, sysutils;
type
    habitacion = record
        nombre: string;
        precio: integer;
    end;
    cliente = record
        nombre: string;
        apellido: string;
        documento: string;
        email: string;
        telefono: string;
    end;
    nino = record
        nombre: string;
        apellido: string;
        edad: integer;
    end;
    reservacion = record
        id: integer;
        tReservacion: string;
        tHabitacion: habitacion;
        diasEstadia: integer;
        clientesEnSesion: array of cliente;
        ninosEnSesion: array of nino;
        precioTotal: real;
    end;

const
    tReservaciones: array[1..3] of RawByteString = ('Individual', 'Acompañado', 'Grupo-Familia');
    tipoHab: array [1..4] of habitacion = (
       (nombre: 'Sencilla'; precio: 60),
       (nombre: 'Doble'; precio: 120),
       (nombre: 'Family Room'; precio: 200),
       (nombre: 'Suite'; precio: 300));

var
archivoIndividual, archivoAcompanado, archivoGF: Text;
reservacionActual: reservacion;
IDSel, op1, op2: string;
resIndSis, resAcoSis, resGFSis, resSel: array of reservacion;

function esEdad(e: string): boolean;
var i:integer;
begin
    esEdad:=true;
    if (e='') then
    begin
        esEdad:=false;
        exit;
    end;
    for i:=1 to length(e) do
    begin
        if not (e[i] in ['0'..'9']) then
        begin
            esEdad:=false;
            exit;
        end;
    end;
end;

function esNombreApellido(s: string): boolean;
var i: integer;
begin
    esNombreApellido:=true;
    if (s='') then
    begin
        esNombreApellido:=false;
        exit;
    end;
    for i:=1 to length(s) do
    begin
        if (not (s[i] in ['a'..'z', 'A'..'Z'])) then
        begin
            esNombreApellido:=false;
            exit;
        end;
    end;
end;

function esDocumento(s: string): boolean;
var i: integer;
begin
    esDocumento:=true;
    if ((s[1]='0') or (s='')) then
    begin
        esDocumento:=false;
        exit;
    end;
    for i:=1 to length(s) do
    begin
        if (not (s[i] in ['0'..'9'])) then
        begin
            esDocumento:=false;
            exit;
        end;
    end;
end;

function esID(s: string): boolean;
var i: integer;
begin
    esID:=true;
    if (s='') then
    begin
        esID:=false;
        exit;
    end;
    for i:=1 to length(s) do
    begin
        if not (s[i] in ['0'..'9']) then
        begin
            esID:=false;
            exit;
        end;
    end;
end;

function esMail(s: string): boolean;
var i: integer;
begin
    esMail:=true;
    if (s='') then
    begin
        esMail:=false;
        exit;
    end;
    for i:=1 to length(s) do
    begin
        if (s[i]=' ') then
        begin
            esMail:=false;
            exit;
        end;
    end;
end;

function esTel(s: string): boolean;
var i: integer;
begin
    esTel:=true;
    if (s='') then
    begin
        esTel:=false;
        exit;
    end;
    for i:=1 to length(s) do
    begin
        if not (s[i] in ['0'..'9']) then
        begin
            esTel:=false;
            exit;
        end;
    end;
end;

function esDia(s: string): boolean;
var i: integer;
begin
    esDia:=true;
    if (s='') then
    begin
        esDia:=false;
        exit;
    end;
    for i:=1 to length(s) do
    begin
        if not (s[i] in ['0'..'9']) then
        begin
            esDia:=false;
            exit;
        end;
    end;
    if (StrToInt(s)<=0) then
    begin
        esDia:=false;
        exit;
    end;
end;

function determinarId(var archivo: Text; nombreArchivo: string): integer;
var
linea: string;
idmax: integer;
begin
    idmax:=0;
    if(FileExists(nombreArchivo)) then
    begin
        assign(archivo, nombreArchivo);
        reset(archivo);
        while not (eof(archivo)) do
        begin
            readLn(archivo, linea);
            if(Copy(linea, 1, 2)='ID') then
            begin
                if (StrToInt(Copy(linea, 5, length(linea)))>idmax) then
                begin
                    idmax:=StrToInt(Copy(linea, 5, length(linea)));
                end;
            end;
        end;
        close(archivo);
    end;
    determinarId:=idmax+1;
end;

function seleccionarTHab(): habitacion;
var
opp1, opp2: string;
begin
    repeat //PONER BONITO
        clrscr;
        writeln('Por favor, indique el tipo de habitacion:');
        writeln('1. Sencilla.');
        writeln('2. Doble.');
        writeln('3. Family Room.');
        writeln('4. Suite.');
        opp1:=readkey;
        clrscr;
        case (opp1) of
            '1': begin
                writeln('Amplia y confortable habitación decorada con un estilo vanguardista, cama Lidotel Royal King con sábanas');
                writeln('de algodón egipcio, soporte para iPod con reloj despertador, TV 32” HD Plasma con cable, baño con ducha,');
                writeln('cafetera eléctrica, nevera ejecutiva, caja electrónica de seguridad y secador de cabello.');
                writeln('Incluye:');
                writeln('Desayuno Buffet en Restaurant Le Nouveau, acceso inalámbrico a Internet (WIFI), acceso a las instalaciones');
                writeln('del Business Center, uso de nuestra exclusiva piscina, acceso a nuestro moderno gimnasio y Kit de vanidades.');
                writeln('Niños de 0 a 2 años sin recargos.');
            end;
            '2': begin
                writeln('Amplia y confortable habitación decorada con un estilo vanguardista, Dos Camas Lidotel Full con sábanas de');
                writeln('algodón egipcio, soporte para iPod con reloj despertador, TV 32” HD Plasma con cable, baño con ducha,');
                writeln('cafetera eléctrica, nevera ejecutiva, caja electrónica de seguridad secador de cabello.');
                writeln('Incluye:');
                writeln('Desayuno Buffet en el Restaurant Le Nouveau, acceso inalámbrico a Internet (WIFI), acceso a las instalaciones');
                writeln('del Business Center, uso de nuestra exclusiva piscina, acceso a nuestro moderno gimnasio y Kit de vanidades.');
                writeln('Niños de 0 a 2 años sin recargos.');
            end;
            '3': begin
                writeln('Cálida y confortable habitación decorada con un estilo vanguardista, 100% libre de humo, cama Lidotel Royal');
                writeln('King, con reloj despertador, TV 32” HD Plasma con cable, baño con ducha, cafetera eléctrica, nevera ejecutiva,');
                writeln('caja electrónica de seguridad y secador de cabello, armario adicional amplio, una habitación separada con 2');
                writeln('camas full, baño con ducha.');
                writeln('Incluye:');
                writeln('Desayuno Buffet en el Restaurant Le Nouveau, acceso inalámbrico a Internet (WIFI), Business Center, uso de');
                writeln('nuestra exclusiva piscina, acceso a nuestro gimnasio, sillas y toldos en la playa, kit de vanidades y niños');
                writeln('de 0 a 2 años sin recargos.');
            end;
            '4': begin
                writeln('Cálida y confortable habitación decorada con un estilo vanguardista, 100% libre de humo, Cama Lidotel Royal');
                writeln('King, con reloj despertador, TV 32” HD Plasma con cable, 2 baños con ducha, cafetera eléctrica, nevera');
                writeln('ejecutiva, caja electrónica de seguridad y secador de cabello, armario adicional amplio y área separada con 2');
                writeln('sofá-cama individuales.');
                writeln('Incluye:');
                writeln('Desayuno Buffet en el Restaurant Le Nouveau, acceso inalámbrico a Internet (WIFI), Business Center, uso de');
                writeln('nuestra exclusiva piscina, acceso a nuestro gimnasio, sillas y toldos en la playa, kit de vanidades y niños');
                writeln('de 0 a 2 años sin recargos.')
            end
            else begin
                writeln('Opcion no valida.');
                delay(2000);
            end;
        end;
        writeln('Precio: ', tipoHab[StrToInt(opp1)].precio, '$/noche.');
        writeln('Presione cualquier tecla para continuar...');
        readkey;
        if (opp1[1] in ['1','2','3','4']) then
        begin
            repeat
                clrscr;
                writeln('Desea confirmar su seleccion? (S/N)');
                opp2:=readkey;
                case (opp2) of
                    's', 'S': begin
                        writeln('Habitacion confirmada exitosamente.');
                        seleccionarTHab:=tipoHab[StrToInt(opp1)];
                    end;
                    'n', 'N': begin
                        writeln('Seleccion cancelada.');
                    end
                    else begin
                        writeln('Opcion no valida.');
                    end;
                end;
                delay(2000);
            until (opp2[1] in ['s', 'S', 'n', 'N']);
        end;
    until (opp1[1] in ['1','2','3','4']) and (opp2[1] in ['s', 'S']);
end;

procedure actualizarArchivo(var archivo: Text; nombreArchivo: string; reservaciones: array of reservacion);
var i, j: integer;
begin
    assign(archivo, nombreArchivo);
    rewrite(archivo);
    for i:=0 to length(reservaciones)-1 do
    begin
        writeLn(archivo, 'Datos de la reserva:');
        writeLn(archivo, 'ID: ', reservaciones[i].id);
        writeLn(archivo, 'Tipo de reserva: ', reservaciones[i].tReservacion);
        writeLn(archivo, 'Tipo de habitacion: ', reservaciones[i].tHabitacion.nombre);
        writeLn(archivo, 'Dias de estadia: ', reservaciones[i].diasEstadia);
        writeLn(archivo, 'Precio total: ', (reservaciones[i].precioTotal):0:2, '$');
        writeLn(archivo, 'Informacion de clientes:');
        for j:=0 to length(reservaciones[i].clientesEnSesion)-1 do
        begin
            writeLn(archivo, 'Adulto ', j+1, ':');
            with reservaciones[i].clientesEnSesion[j] do
            begin
                writeLn(archivo, '   Nombre: ', nombre);
                writeLn(archivo, '   Apellido: ', apellido);
                writeLn(archivo, '   Documento: ', documento);
                writeLn(archivo, '   E-mail: ', email);
                writeLn(archivo, '   Telefono: ', telefono);
            end;
        end;
        for j:=0 to length(reservaciones[i].ninosEnSesion)-1 do
        begin
            writeLn(archivo, 'Niño ', j+1, ':');
            with reservaciones[i].ninosEnSesion[j] do
            begin
                writeLn(archivo, '   Nombre: ', nombre);
                writeLn(archivo, '   Apellido: ', apellido);
                writeLn(archivo, '   Edad: ', edad);
            end;
        end;
        writeLn(archivo, '----------------------------------------------------------------------------------');
    end;
    close(archivo);
end;

function existeReservacion(var archivo: Text; nombreArchivo: string; ID: integer): boolean;
var linea: string;
begin
    if (FileExists(nombreArchivo)) then
    begin
        assign(archivo, nombreArchivo);
        reset(archivo);
        while not eof(archivo) do
        begin
            readLn(archivo, linea);
            if (linea=('ID: ' + IntToStr(ID))) then
            begin
                existeReservacion:=true;
                close(archivo);
                exit;
            end;
        end;
        existeReservacion:=false;
        close(archivo);
    end
    else begin
        existeReservacion:=false;
    end;
end;

function getReservacion(var archivo: Text; nombreArchivo: string; ID: integer): reservacion;
var
linea: string;
encontrado, esAdulto, esNino: boolean;
nAdultoActual, nNinoActual: integer;
begin
    encontrado:=false;
    esAdulto:=false;
    esNino:=false;
    nAdultoActual:=0;
    nNinoActual:=0;
    assign(archivo, nombreArchivo);
    reset(archivo);
    while not eof(archivo) do
    begin
        readLn(archivo, linea);
        if (linea=('ID: ' + IntToStr(ID))) then
        begin
            getReservacion.id:= StrToInt(Copy(linea, 5, length(linea)));
            encontrado:=true;
        end;
        if(encontrado) then
        begin
            if (Copy(linea, 1, 16)=('Tipo de reserva:')) then
            begin
                getReservacion.tReservacion:= Copy(linea, 18, length(linea));
            end;
            if (Copy(linea, 1, 19)=('Tipo de habitacion:')) then
            begin
                case(Copy(linea, 21, length(linea))) of
                    'Sencilla': begin
                        getReservacion.tHabitacion:= tipoHab[1];
                    end;
                    'Doble': begin
                        getReservacion.tHabitacion:= tipoHab[2];
                    end;
                    'Family Room': begin
                        getReservacion.tHabitacion:= tipoHab[3];
                    end;
                    'Suite': begin
                        getReservacion.tHabitacion:= tipoHab[4];
                    end;
                end;
            end;
            if (Copy(linea, 1, 16)=('Dias de estadia:')) then
            begin
                getReservacion.diasEstadia:= StrToInt(Copy(linea, 18, length(linea)));
            end;
            if (Copy(linea, 1, 13)=('Precio total:')) then
            begin
                Delete(linea, 1, 14);
                Delete(linea, length(linea), 1);
                getReservacion.precioTotal:= StrToFloat(linea);
            end;
            if (Copy(linea, 1, 6)=('Adulto'))then
            begin
                Delete(linea, 1, 7);
                Delete(linea, length(linea), 1);
                if(StrToInt(linea)>nAdultoActual) then
                begin
                    nAdultoActual+=1;
                    setLength(getReservacion.clientesEnSesion, nAdultoActual);
                    esAdulto:=true;
                    esNino:=false;
                end;
            end;
            if(esAdulto) then
            begin
                if (Copy(linea, 1, 10)='   Nombre:') then
                begin
                    getReservacion.clientesEnSesion[nAdultoActual-1].nombre:=Copy(linea, 12, length(linea));
                end;
                if (Copy(linea, 1, 12)='   Apellido:') then
                begin
                    getReservacion.clientesEnSesion[nAdultoActual-1].apellido:=Copy(linea, 14, length(linea));
                end;
                if (Copy(linea, 1, 13)='   Documento:') then
                begin
                    getReservacion.clientesEnSesion[nAdultoActual-1].documento:=Copy(linea, 15, length(linea));
                end;
                if (Copy(linea, 1, 10)='   E-mail:') then
                begin
                    getReservacion.clientesEnSesion[nAdultoActual-1].email:=Copy(linea, 12, length(linea));
                end;
                if (Copy(linea, 1, 12)='   Telefono:') then
                begin
                    getReservacion.clientesEnSesion[nAdultoActual-1].telefono:=Copy(linea, 14, length(linea));
                end;
            end;
            if (UnicodeString(Copy(linea, 1, 4))=('Niño')) then
            begin
                Delete(linea, 1, 5);
                Delete(linea, length(linea), 1);
                if(StrToInt(linea)>nNinoActual) then
                begin
                    nNinoActual+=1;
                    setLength(getReservacion.ninosEnSesion, nNinoActual);
                    esNino:=true;
                    esAdulto:=false;
                end;
            end;
            if(esNino) then
            begin
                if (Copy(linea, 1, 10)='   Nombre:') then
                begin
                    getReservacion.ninosEnSesion[nNinoActual-1].nombre:=Copy(linea, 12, length(linea));
                end;
                if (Copy(linea, 1, 12)='   Apellido:') then
                begin
                    getReservacion.ninosEnSesion[nNinoActual-1].apellido:=Copy(linea, 14, length(linea));
                end;
                if (Copy(linea, 1, 8)='   Edad:') then
                begin
                    getReservacion.ninosEnSesion[nNinoActual-1].edad:=StrToInt(Copy(linea, 10, length(linea)));
                end;
            end;
            if(linea='----------------------------------------------------------------------------------') then
            begin
                close(archivo);
                exit;
            end;
        end;
    end;
    close(archivo);
end;

procedure cargarArchivos();
var idmax, i: integer;
begin
    if(FileExists('Reservas Individual.txt')) then
    begin
        idmax:=determinarId(archivoIndividual, 'Reservas Individual.txt')-1;
        for i:=0 to idmax do
        begin
            if(existeReservacion(archivoIndividual, 'Reservas Individual.txt', i)) then
            begin
                setLength(resIndSis, length(resIndSis)+1);
                resIndSis[length(resIndSis)-1]:=getReservacion(archivoIndividual, 'Reservas Individual.txt', i);
            end;
        end;
    end;
    if (FileExists('Reservas Acompañado.txt')) then
    begin
        idmax:=determinarId(archivoAcompanado, 'Reservas Acompañado.txt')-1;
        for i:=0 to idmax do
        begin
            if(existeReservacion(archivoAcompanado, 'Reservas Acompañado.txt', i)) then
            begin
                setLength(resAcoSis, length(resAcoSis)+1);
                resAcoSis[length(resAcoSis)-1]:=getReservacion(archivoAcompanado, 'Reservas Acompañado.txt', i);
            end;
        end;
    end;
    if (FileExists('Reservas Grupo-Familia.txt')) then
    begin
        idmax:=determinarId(archivoGF, 'Reservas Grupo-Familia.txt')-1;
        for i:=0 to idmax do
        begin
            if(existeReservacion(archivoGF, 'Reservas Grupo-Familia.txt', i)) then
            begin
                setLength(resGFSis, length(resGFSis)+1);
                resGFSis[length(resGFSis)-1]:=getReservacion(archivoGF, 'Reservas Grupo-Familia.txt', i);
            end;
        end;
    end;
end;

procedure mostrarDatosReservacion(reservaciones: array of reservacion; pos: integer);
var j: integer;
begin
    writeln('Datos de la reserva:');
    with reservaciones[pos] do
    begin
        writeln('ID: ', id);
        writeln('Tipo de reserva: ', tReservacion);
        writeln('Tipo de habitacion: ', tHabitacion.nombre);
        writeln('Dias de estadia: ', diasEstadia);
        writeln('Precio total: ', (precioTotal):0:2, '$');
    end;
    writeln('Para ver la informacion de los clientes, presione cualquier tecla...');
    readkey;
    clrscr;
    writeln('Informacion de clientes:');
    for j:=0 to length(reservaciones[pos].clientesEnSesion)-1 do
    begin
        writeln('Adulto ', j+1, ':');
        with reservaciones[pos].clientesEnSesion[j] do
        begin
            writeln('   Nombre: ', nombre);
            writeln('   Apellido: ', apellido);
            writeln('   Documento: ', documento);
            writeln('   E-mail: ', email);
            writeln('   Telefono: ', telefono);
        end;
        if((j<length(reservaciones[pos].clientesEnSesion)-1) or (length(reservaciones[pos].ninosEnSesion)>0)) then
        begin
            writeln('Para ver la informacion de la siguiente persona, presione cualquier tecla...');
            readkey;
            clrscr;
        end;
    end;
    for j:=0 to length(reservaciones[pos].ninosEnSesion)-1 do
    begin
        writeLn('Niño ', j+1, ':');
        with reservaciones[pos].ninosEnSesion[j] do
        begin
            writeln('   Nombre: ', nombre);
            writeln('   Apellido: ', apellido);
            writeln('   Edad: ', edad);
        end;
        if(j<length(reservaciones[pos].ninosEnSesion)-1) then
        begin
            writeln('Para ver la informacion de la siguiente persona, presione cualquier tecla...');
            readkey;
            clrscr;
        end;
    end;
end;

procedure nuevaReservacion(var res: reservacion); //PONER BONITO
var
opp, dEstadia, nAdultos, nNinos, nom, ape, tDoc, doc, correo, tel, age: string;
i: integer;
valido: boolean;
begin
    repeat
        clrscr;
        writeln('Por favor, indique el tipo de reservacion:');
        writeln('1. Individual.');
        writeln('2. Acompañado.');
        writeln('3. Grupo-Familia.');
        opp:=readkey;
        case(opp) of
            '1': begin
                setLength(res.clientesEnSesion, 1);
                res.id:=determinarId(archivoIndividual, 'Reservas Individual.txt');
            end;
            '2': begin
                setLength(res.clientesEnSesion, 2);
                res.id:=determinarId(archivoAcompanado, 'Reservas Acompañado.txt');
            end;
            '3': begin
                repeat
                    valido:=true;
                    clrscr;
                    write('Indique la cantidad de adultos:');
                    readln(nAdultos);
                    if not esID(nAdultos) then
                    begin
                        valido:=false;
                    end;
                    if valido then
                    begin
                        if (StrToInt(nAdultos)<=0) then
                        begin
                            valido:=false;
                        end;
                    end;
                    if not valido then
                    begin
                        writeln('Ingrese una cantidad valida.');
                        delay(2000);
                    end;
                until valido;
                repeat
                    write('Indique la cantidad de niños:');
                    readln(nNinos);
                    if not esID(nNinos) then
                    begin
                        writeln('Ingrese una cantidad valida.');
                        delay(2000);
                    end;
                until esID(nNinos);
                setLength(res.clientesEnSesion, StrToInt(nAdultos));
                setLength(res.ninosEnSesion, StrToInt(nNinos));
                res.id:=determinarId(archivoGF, 'Reservas Grupo-Familia.txt');
            end
            else begin
                writeln('Opcion no valida.');
                delay(2000);
            end;
        end;
    until (opp[1] in ['1', '2', '3']);
    repeat
        clrscr;
        write('Ingrese los dias de estadia');
        readln(dEstadia);
        if not esDia(dEstadia) then
        begin
            writeln('Ingrese una cantidad de dias valida.');
            delay(2000);
        end;
    until esDia(dEstadia);
    with res do
    begin
        tReservacion:=tReservaciones[StrToInt(opp)];
        tHabitacion:=seleccionarTHab();
        diasEstadia:=StrToInt(dEstadia);
        precioTotal:=tHabitacion.precio * StrToInt(dEstadia);
    end;
    for i:=0 to length(res.clientesEnSesion)-1 do
    begin
        repeat
            clrscr;
            write('Ingrese el nombre del adulto ', i+1, ':');
            readln(nom);
            if not esNombreApellido(nom) then
            begin
                writeln('Ingrese un nombre valido (Sin numeros, espacios o caracteres especiales).');
                delay(2000);
            end;
        until esNombreApellido(nom);
        repeat
            clrscr;
            write('Ingrese el apellido del adulto ', i+1, ':');
            readln(ape);
            if not esNombreApellido(ape) then
            begin
                writeln('Ingrese un apellido valido (Sin numeros, espacios o caracteres especiales).');
                delay(2000);
            end;
        until esNombreApellido(ape);
        repeat
            clrscr;
            write('Ingrese el tipo de documento del adulto ' , i+1, ' (V/E/J/G/P): ');
            tDoc:=readkey;
            if not (tDoc[1] in ['V','v','E','e','J','j','G','g','P','p']) then
            begin
                writeln('Ingrese un tipo de documento valido.');
                delay(2000);
            end;
        until (tDoc[1] in ['V','v','E','e','J','j','G','g','P','p']);
        repeat
            clrscr;
            write('Ingrese el numero de documento del adulto ', i+1, ': ');
            readln(doc);
            if not esDocumento(doc) then
            begin
                writeln('Ingrese un numero de documento valido.');
                delay(2000);
            end;
        until esDocumento(doc);
        repeat
            clrscr;
            write('Ingrese el correo del adulto ', i+1, ': ');
            readln(correo);
            if not esMail(correo) then
            begin
                writeln('Ingrese un correo valido.');
                delay(2000);
            end;
        until esMail(correo);
        repeat
            clrscr;
            write('Ingrese el telefono del adulto ', i+1, ': ');
            readln(tel);
            if not esTel(tel) then
            begin
                writeln('Ingrese un telefono valido (solo numeros).');
                delay(2000);
            end;
        until esTel(tel);
        with res.clientesEnSesion[i] do
        begin
            nombre:=nom;
            apellido:=ape;
            documento:=UpperCase(tDoc)+doc;
            email:=correo;
            telefono:=tel;
        end;
    end;
    for i:=0 to length(res.ninosEnSesion)-1 do
    begin
        repeat
            clrscr;
            write('Ingrese el nombre del niño ', i+1, ':');
            readln(nom);
            if not esNombreApellido(nom) then
            begin
                writeln('Ingrese un nombre valido (Sin numeros, espacios o caracteres especiales).');
                delay(2000);
            end;
        until esNombreApellido(nom);
        repeat
            clrscr;
            write('Ingrese el apellido del niño ', i+1, ':');
            readln(ape);
            if not esNombreApellido(ape) then
            begin
                writeln('Ingrese un apellido valido (Sin numeros, espacios o caracteres especiales).');
                delay(2000);
            end;
        until esNombreApellido(ape);
        repeat
            clrscr;
            write('Ingrese la edad del niño ', i+1, ':');
            readln(age);
            if not esEdad(age) then
            begin
                writeln('Ingrese una edad valida.');
                delay(2000);
            end;
        until esEdad(age);
        with res.ninosEnSesion[i] do
        begin
            nombre:=nom;
            apellido:=ape;
            edad:=StrToInt(age);
        end;
    end;
    case (opp) of
        '1': begin
            setLength(resIndSis, length(resIndSis)+1);
            resIndSis[length(resIndSis)-1]:=res;
            actualizarArchivo(archivoIndividual, 'Reservas Individual.txt', resIndSis);
            mostrarDatosReservacion(resIndSis, length(resIndSis)-1);
        end;
        '2': begin
            setLength(resAcoSis, length(resAcoSis)+1);
            resAcoSis[length(resAcoSis)-1]:=res;
            actualizarArchivo(archivoAcompanado, 'Reservas Acompañado.txt', resAcoSis);
            mostrarDatosReservacion(resAcoSis, length(resAcoSis)-1);
        end;
        '3': begin
            setLength(resGFSis, length(resGFSis)+1);
            resGFSis[length(resGFSis)-1]:=res;
            actualizarArchivo(archivoGF, 'Reservas Grupo-Familia.txt', resGFSis);
            mostrarDatosReservacion(resGFSis, length(resGFSis)-1);
        end;
    end;
end;

procedure buscarReservacion(reservaciones: array of reservacion; ID: integer);
var
i, posActual: integer;
opp: string;
salir, mostrar: boolean;
begin
    if(length(reservaciones)>0) then
    begin
        for i:=0 to length(reservaciones)-1 do
        begin
            if (reservaciones[i].id=ID) then
            begin
                posActual:=i;
                mostrarDatosReservacion(reservaciones, posActual);
                salir:=false;
                repeat
                    clrscr;
                    writeln('Indique la reservacion que desea ver ahora:');
                    writeln('0. Salir al menu.     1. Anterior.     2. Siguiente.');
                    opp:=readkey;
                    case (opp) of
                        '0': begin
                            salir:=true;
                            mostrar:=false;
                        end;
                        '1': begin
                            if(posActual=0) then
                            begin
                                writeln('No existe una reservacion anterior.');
                                mostrar:=false;
                                delay(2000);
                            end
                            else begin
                                posActual-=1;
                                mostrar:=true;
                            end;
                        end;
                        '2': begin
                            if(posActual=(length(reservaciones)-1)) then
                            begin
                                writeln('No existe una reservacion siguiente.');
                                mostrar:=false;
                                delay(2000);
                            end
                            else begin
                                posActual+=1;
                                mostrar:=true;
                            end;
                        end
                        else begin
                            writeln('Dato no valido.');
                            mostrar:=false;
                            delay(2000);
                        end;
                    end;
                    if (mostrar) then
                    begin
                        mostrarDatosReservacion(reservaciones, posActual);
                    end;
                until salir;
                exit;
            end;
        end;
        writeln('No se ha conseguido ninguna reservacion con esa ID.');
        delay(2000);
    end
    else begin
        writeln('No se ha conseguido ninguna reservacion con esa ID.');
        delay(2000);
    end;
end;

procedure solicitarDatos(num: integer);
begin
    repeat
        case (num) of
            1: begin
                writeln('Por favor, indique el tipo de reservacion que desea buscar:');
            end;
            2: begin
                writeln('Por favor, indique el tipo de reservacion que desea modificar:');
            end;
        end;
        writeln('1. Individual.');
        writeln('2. Acompañado.');
        writeln('3. Grupo-Familia.');
        op2:=readkey;
        case (op2) of
            '1': begin
                resSel:= resIndSis;
            end;
            '2': begin
                resSel:= resAcoSis;
            end;
            '3': begin
                resSel:= resGFSis;
            end
            else begin
                writeln('Opcion no valida');
                delay(2000);
            end;
        end;
    until (op2[1] in ['1','2','3']);
    repeat
        clrscr;
        writeln('Por favor, indique el ID de la reserva que desea buscar:');
        readln(IDSel);
        if not esID(IDSel) then
        begin
            writeln('Ingrese un ID valido.');
            delay(2000);
        end;
    until esID(IDSel);
end;

procedure modificarReservacion(var reservaciones: array of reservacion; ID: integer);
var
i, j: integer;
opp, dias, nom, ape, tDoc, doc, correo, tel, age: string;
next: boolean;
begin
    if(length(reservaciones)>0) then
    begin
        for i:=0 to length(reservaciones)-1 do
        begin
            if (reservaciones[i].id=ID) then
            begin
                with reservaciones[i] do
                begin
                    next:=false;
                    repeat
                        clrscr;
                        writeLn('Datos de la reserva (Indique el que desea modificar):');
                        writeln('1. Tipo de habitacion: ', tHabitacion.nombre);
                        writeln('2. Dias de estadia: ', diasEstadia);
                        writeln('3. Siguiente.');
                        writeln('4. Salir al menu.');
                        opp:=readkey;
                        case (opp) of
                            '1': begin
                                tHabitacion:=seleccionarTHab();
                                precioTotal:=tHabitacion.precio*diasEstadia;
                            end;
                            '2': begin
                                repeat
                                    clrscr;
                                    writeln('Ingrese la cantidad de dias de su estadia: ');
                                    readln(dias);
                                    if not esDia(dias) then
                                    begin
                                        writeln('Ingrese una cantidad de dias valida.');
                                        delay(2000);
                                    end;
                                until esDia(dias);
                                diasEstadia:=StrToInt(dias);
                                precioTotal:=tHabitacion.precio*diasEstadia;
                            end;
                            '3': begin
                                next:=true;
                            end;
                            '4': begin
                                exit;
                            end
                            else begin
                                writeln('Dato no valido.');
                                delay(2000);
                            end;
                        end;
                    until next;
                    for j:=0 to length(clientesEnSesion)-1 do
                    begin
                        next:=false;
                        repeat
                            clrscr;
                            writeln('Datos del adulto ', j+1, ' (Indique el que desea modificar):');
                            with clientesEnSesion[j] do
                            begin
                                writeln('1. Nombre: ', nombre);
                                writeln('2. Apellido: ', apellido);
                                writeln('3. Documento: ', documento);
                                writeln('4. E-mail: ', email);
                                writeln('5. Telefono: ', telefono);
                                writeln('6. Siguiente.');
                                writeln('7. Salir al menu.');
                                opp:=readkey;
                                case (opp) of
                                    '1': begin
                                        repeat
                                            clrscr;
                                            writeln('Ingrese el nombre del adulto ', j+1, ': ');
                                            readln(nom);
                                            if not esNombreApellido(nom) then
                                            begin
                                                writeln('Ingrese un nombre valido (Sin numeros, espacios o caracteres especiales).');
                                                delay(2000);
                                            end;
                                        until esNombreApellido(nom);
                                        nombre:=nom;
                                    end;
                                    '2': begin
                                        repeat
                                            clrscr;
                                            writeln('Ingrese el apellido del adulto ', j+1, ': ');
                                            readln(ape);
                                            if not esNombreApellido(ape) then
                                            begin
                                                writeln('Ingrese un apellido valido (Sin numeros, espacios o caracteres especiales).');
                                                delay(2000);
                                            end;
                                        until esNombreApellido(ape);
                                        apellido:=ape;
                                    end;
                                    '3': begin
                                        repeat
                                            clrscr;
                                            write('Ingrese el tipo de documento del adulto ' , j+1, ' (V/E/J/G/P): ');
                                            tDoc:=readkey;
                                            if not (tDoc[1] in ['V','v','E','e','J','j','G','g','P','p']) then
                                            begin
                                                writeln('Ingrese un tipo de documento valido.');
                                                delay(2000);
                                            end;
                                        until (tDoc[1] in ['V','v','E','e','J','j','G','g','P','p']);
                                        repeat
                                            write('Ingrese el numero de documento del adulto ', j+1, ':');
                                            readln(doc);
                                            if not esDocumento(doc) then
                                            begin
                                                writeln('Ingrese un numero de documento valido.');
                                                delay(2000);
                                            end;
                                        until (esDocumento(doc));
                                        documento:=UpperCase(tDoc)+doc;
                                    end;
                                    '4': begin
                                        repeat
                                            clrscr;
                                            writeln('Ingrese el correo del adulto ', j+1, ':');
                                            readln(correo);
                                            if not esMail(correo) then
                                            begin
                                                writeln('Ingrese un correo valido.');
                                            end;
                                        until esMail(correo);
                                        email:=correo;
                                    end;
                                    '5': begin
                                        repeat
                                            clrscr;
                                            write('Ingrese el telefono del adulto ', j+1, ':');
                                            readln(tel);
                                            if not esTel(tel) then
                                            begin
                                                writeln('Ingrese un telefono valido (solo numeros).');
                                                delay(2000);
                                            end;
                                        until esTel(tel);
                                        telefono:=tel;
                                    end;
                                    '6': begin
                                        next:=true;
                                    end;
                                    '7': begin
                                        exit;
                                    end
                                    else begin
                                        writeln('Dato no valido.');
                                        delay(2000);
                                    end;
                                end;
                            end;
                        until next;
                    end;
                    for j:=0 to length(ninosEnSesion)-1 do
                    begin
                        next:=false;
                        repeat
                            clrscr;
                            writeln('Datos del niño ', j+1, ' (Indique el que desea modificar):');
                            with ninosEnSesion[j] do
                            begin
                                writeln('1. Nombre: ', nombre);
                                writeln('2. Apellido: ', apellido);
                                writeln('3. Edad: ', edad);
                                writeln('4. Siguiente.');
                                writeln('5. Salir al menu.');
                                opp:=readkey;
                                case (opp) of
                                    '1': begin
                                        repeat
                                            clrscr;
                                            writeln('Ingrese el nombre del niño ', j+1, ': ');
                                            readln(nom);
                                            if not esNombreApellido(nom) then
                                            begin
                                                writeln('Ingrese un nombre valido (Sin numeros, espacios o caracteres especiales).');
                                                delay(2000);
                                            end;
                                        until esNombreApellido(nom);
                                        nombre:=nom;
                                    end;
                                    '2': begin
                                        repeat
                                            clrscr;
                                            writeln('Ingrese el apellido del niño ', j+1, ': ');
                                            readln(ape);
                                            if not esNombreApellido(ape) then
                                            begin
                                                writeln('Ingrese un apellido valido (Sin numeros, espacios o caracteres especiales).');
                                                delay(2000);
                                            end;
                                        until esNombreApellido(ape);
                                        apellido:=ape;
                                    end;
                                    '3': begin
                                        repeat
                                            clrscr;
                                            writeln('Ingrese la edad del niño ', j+1, ':');
                                            readln(age);
                                            if not esEdad(age) then
                                            begin
                                                writeln('Ingrese una edad valida.');
                                                delay(2000);
                                            end;
                                        until esEdad(age);
                                        edad:=StrToInt(age);
                                    end;
                                    '4': begin
                                        next:=true;
                                    end;
                                    '5': begin
                                        exit;
                                    end
                                    else begin
                                        writeln('Dato no valido.');
                                        delay(2000);
                                    end;
                                end;
                            end;
                        until next;
                    end;
                end;
            end
            else begin
                if (i=length(reservaciones)-1) then
                begin
                    writeln('No se ha conseguido ninguna reservacion con esa ID.');
                    delay(2000);
                end;
            end;
        end;
    end
    else begin
        writeln('No se ha conseguido ninguna reservacion con esa ID.');
        delay(2000);
    end;
end;

//MAIN
begin
    clrscr;
    cargarArchivos();
    writeln('');
    writeln('Bienvenido al sistema del Hotel Lidotel Boutique Margarita!');
    writeln('Presione cualquier tecla para continuar...');
    readkey;
    repeat
        clrscr;
        writeln('Por favor indique la operacion a realizar:');
        writeln('1. Nuevo cliente.');
        writeln('2. Buscar reservacion.');
        writeln('3. Modificar reservacion.');
        writeln('4. Salir.');
        op1:=readkey;
        case(op1) of
            '1': begin
                nuevaReservacion(reservacionActual);
            end;
            '2': begin
                solicitarDatos(1);
                buscarReservacion(resSel, StrToInt(IDSel));
            end;
            '3': begin
                solicitarDatos(2);
                modificarReservacion(resSel, StrToInt(IDSel));
                case (op2) of
                    '1': begin
                        actualizarArchivo(archivoIndividual, 'Reservas Individual.txt', resSel);
                    end;
                    '2': begin
                        actualizarArchivo(archivoAcompanado, 'Reservas Acompañado.txt', resSel);
                    end;
                    '3': begin
                        actualizarArchivo(archivoGF, 'Reservas Grupo-Familia.txt', resSel);
                    end;
                end;
            end;
            '4': begin
                writeln('Gracias por usar el sistema, vuelva pronto.');
                delay(3000);
            end
            else begin
                writeln('Opcion no valida.');
                delay(2000);
            end;
        end;
    until (op1[1]='4');
end.