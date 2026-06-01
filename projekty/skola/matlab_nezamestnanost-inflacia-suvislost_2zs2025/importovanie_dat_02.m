% prikazy cerpane z https://www.mathworks.com/help/matlab/ ; https://www.mathworks.com/matlabcentral/answers/
% matlab(30-dnova-verzia)
% Martina Szentpeteriova_uloha2_posledna-uprava(17.10.2025)
% korelacia nezamestnanost/inflacia

% importovanie_dat_02.m
% importovanie dat z xls suborov MS_RR_MM.xlsx a PMI_2101_2509.xlsx
% data: nezamestnanost, pocet nezamestnanych, inflacia

% cesta k suboru (upravit podla vlastneho umiestnenia nemusim vdaka pwd=print working directory)
% aktualny priecinok a cesta k suboru
cesta = fullfile(pwd, 'data') % vytvori cestu do podpriecinku data kde su .xlsx subory
% 'C:/Users/Martina/Documents/MATLAB/matlab_projekt-szentpeteriova/data/';

% ulozenie hodnot do pola kedze citame viacero suborov zaradom
nezamestnanost_data = {};
for rok = 2021:2025
    for mesiac = 1:12
        if rok == 2025 && mesiac > 9
            continue;
        end
        % citanie dat zo suborov zaradom podla ich nazvov 
        % (d=berie do uvahy 2 cislice)
        rr = num2str(mod(rok,100), '%02d');
        mm = num2str(mesiac, '%02d');
        fprintf('Načítavam rr: %s, mm: %s\n', rr, mm);
        % cesta k suboru + nazov suboru (napr. MS_2101.xlsx)
        nezam_subor = fullfile(cesta, ['MS_' rr mm '.xlsx']);
        if exist(nezam_subor, 'file')
            try
                bunka_miera = 'O98';
                bunka_pocet = 'M98';
                fprintf('Načítavam bunka_miera: %s, bunka_pocet: %s, rok: %d\n', bunka_miera, bunka_pocet, rok);
                if rok <= 2022
                    % nazov = precitajmaticu(subor, 'Hárok', 'jeho meno',
                    % 'rozsah/ktora bunka', 'nazov konkretnej bunky')
                    miera_nezam = readcell(nezam_subor, 'Sheet', 'Tab1', 'Range', [bunka_miera ':' bunka_miera]);
                    pocet_nezam = readcell(nezam_subor, 'Sheet', 'Tab1', 'Range', [bunka_pocet ':' bunka_pocet]);

                    if isempty(miera_nezam) || isempty(pocet_nezam)
                         warning('⚠️ Prázdna bunka v %s – preskakujem.', nezam_subor);
                       continue;
                    end	% -------koniec nasej 'if is empty' vetvy-------

                    fprintf('Načítavam rok<=2022 mieza_nezam: %s, pocet_nezam: %s\n', num2str(miera_nezam{1}), num2str(pocet_nezam{1}));

                else
                    bunka_miera = 'F19';
                    bunka_pocet = 'D19';
                    miera_nezam = readcell(nezam_subor, 'Sheet', 'Tab1a', 'Range', [bunka_miera ':' bunka_miera]);
                    pocet_nezam = readcell(nezam_subor, 'Sheet', 'Tab1a', 'Range', [bunka_pocet ':' bunka_pocet]);
                    
                    if isempty(miera_nezam) || isempty(pocet_nezam)
                         warning('⚠️ Prázdna bunka v %s – preskakujem. \n', nezam_subor);
                       continue;
                    end
                    fprintf('Načítavam rok>2022 (2023, 2024, 2025) mieza_nezam : %s, pocet_nezam: %s\n', num2str(miera_nezam{1}), num2str(pocet_nezam{1}))
                    
                end
                datum = datetime(rok, mesiac, 1);
                fprintf('Načítavam datum: %s,', datum);
                nezamestnanost_data = [nezamestnanost_data; {datum, pocet_nezam, miera_nezam}];
                fprintf('Načítavam zo suborov MS_rrmm(napr. MS_2101/MS_2508) nezam_data: %s\n', nezamestnanost_data);

            end
        end
    end
end
disp(class(nezamestnanost_data))
whos nezamestnanost_data
nezamestnanost_tbl = cell2table(nezamestnanost_data, 'VariableNames', {'Datum','PocetNezamestnanych','MieraNezamestnanosti'});
% rozbali bunky v stlpcoch z ich vektoroveho 'chlievika' 
% v stlpcoch PocetNezamestnanych a MieraNezamestnanosti na cisla
if iscell(nezamestnanost_tbl.PocetNezamestnanych)
    nezamestnanost_tbl.PocetNezamestnanych = cellfun(@(x) x, nezamestnanost_tbl.PocetNezamestnanych);
end
if iscell(nezamestnanost_tbl.MieraNezamestnanosti)
    nezamestnanost_tbl.MieraNezamestnanosti = cellfun(@(x) x, nezamestnanost_tbl.MieraNezamestnanosti);
end

fprintf('\nKonvertujem nezam_data na tabuľku ....\n');
disp(nezamestnanost_tbl)

% inflacia
fprintf('\nNačítavam infl_subor z cesty PMI_2101_2509.xlsx ..... \n');
infl_subor = fullfile(cesta, 'PMI_2101_2509.xlsx')

% ponechanie nazvov povodnych stlpcov
fprintf('\nČítam infl_subor a ukladám do tabuľky infl_tbl ....\n');
infl_tbl = readtable(infl_subor, 'VariableNamingRule', 'preserve');
fprintf('\nVypisujem tabuľku infl_tbl s údajmi zo súboru PMI_2101_2509.xlsx ....\n');
disp(infl_tbl)

% ciselne udaje su na riadkoch 3 az 58 (1/2 su zahlavie a 59 je september
% ktory nevyuzivame pri porovnavani s nezamestnanostou lebo ta je po
% september
fprintf('\nNačítavam bunky do inflacia_data na riadkoch 3 az 58 ....\n');

% uklada data z inflacie do riadkov - buniek o velkosti 3 stlpce (datum,
% medziroc infl, medzimes infl)
inflacia_data = cell(0,3);

% pomocny vypis aby sme videli ako (akeho typu) su ulozene inflacie zo
% suboru .xlsx
fprintf('\nVypisujem pole buniek inflacia_data ....\n');
disp(inflacia_data)

% kedze som subory citala aj v exceli
% viem ze vyuzitelne udaje su na riadkoch 3 az 58 
for i = 3:58
    try
        % zoberie v prvom stlpci aktualneho riadku i
        datum_orig = infl_tbl{i,1};
        % ak je v bunke datum (typ hodnoty=datum), vytiahne si ju
        if iscell(datum_orig)
            datum_orig = datum_orig{1};
        end

        % skontroluj, ci je datum platny
        % ak je prazdny alebo nieje casoudajoveho typu alebo oboje naraz
        if isempty(datum_orig) || isequal(datum_orig, 'NaT') || (isdatetime(datum_orig) && isnat(datum_orig))
            % preskoci sa riadok
            fprintf('Preskakujem riadok %d s neplatným dátumom.\n', i);
            % pokracuje sa dalej
            continue;
        end

        % ak je datum pismeno alebo retazec znakov, pretypujeme ho 
        % na datetime (casodatumovy udaj)
        if ischar(datum_orig) || isstring(datum_orig)
            % datetime(datum, 'co chceme robit', 'format datumu')
            datum = datetime(datum_orig, 'InputFormat', 'dd-MMM-yyyy');
        elseif isdatetime(datum_orig)
            % ak je datum spravneho typu (casovy udaj) ulozime tak ako je
            datum = datum_orig;
        else
            % vyhodenie chyby ak by nastala aby bolo vidiet
            error('Neočakávaný typ dátumu v riadku %d.\n', i);
        end
        
        % tabulky s ktorymi pracujeme (maju surove udaje - 
        % este neopracovane)
        % medziR = riadok i, stl 2; medziM = riadok i, stl 3
        medzirocna_raw = infl_tbl{i,2};
        medzimesacna_raw = infl_tbl{i,3};

        % kontrola na <missing> - ak chyba nejaky udaj
        % napr v bunke nieje hodnota ale pomlcka/nic
        if ismissing(medzirocna_raw) || ismissing(medzimesacna_raw)
            fprintf('Preskakujem riadok %d s missing hodnotami.\n', i);
            % preskoci sa a pokracuje sa v cykle dalej
            continue;
        end
        
        % ak su nase surove udaje ciselne ulozime ich tak ako su
        if isnumeric(medzirocna_raw)
            medzirocna = medzirocna_raw;
        else
            % ak niesu pretypujeme ich na typ velkosti double
            medzirocna = str2double(medzirocna_raw);
        end
        
        if isnumeric(medzimesacna_raw)
            medzimesacna = medzimesacna_raw;
        else
            medzimesacna = str2double(medzimesacna_raw);
        end
        % pomocny vypis aby sme videli ako nacitava udaje a uklada to
        % tabuliek
        fprintf('Riadok %d: medzirocna_raw=%s, medzimesacna_raw=%s, medzirocna=%.4f, medzimesacna=%.4f\n', ...
        i, string(medzirocna_raw), string(medzimesacna_raw), medzirocna, medzimesacna);


        % velkost tabulky
        % sa bude zvysovat podla toho kolko udajov nacita
        % ten nas povodny riadok 3 buniek na zaciatku (0,3)
        % a v inflacia data budu 3 stlpce (datum, medziR infl, medziM infl)
        inflacia_data(end+1,:) = {datum, medzirocna, medzimesacna};
    % ak odchyti chybu, vypise na konzolu co sa stalo (zlyhanie) a kde
    catch ME
        fprintf('\nChyba pri riadku %d: %s\n', i, ME.message);
    end
end

% konverzia na tabulku (cell to table)
inflacia_tbl = cell2table(inflacia_data, 'VariableNames', {'Datum','MedzirocnaInflacia','MedzimesacnaInflacia'});

% odstranenie riadkov s nenulovymi hodnotami (kde chybaju = remove missing) v medzirocnej inflacii
inflacia_tbl = rmmissing(inflacia_tbl, 'DataVariables', {'MedzirocnaInflacia'});

% odstranenie casovej zlozky (nastavenie na zaciatok mesiaca)
% vsetky datumy typov napr. 2024-03-15 13:45:00 ,2024-03-01, 2024-03-31
% nastavi na rovnake hodnoty (zaciatok marec-2024) kedze s takym datumom pracujeme
% zvysne ukazovatele casu zanedba
inflacia_tbl.Datum = dateshift(inflacia_tbl.Datum, 'start', 'month');

% to iste aj pre nezamestnanost
nezamestnanost_tbl.Datum = dateshift(nezamestnanost_tbl.Datum, 'start', 'month');



% vonkajsie spojenie stlpcov do jednej tabulky -> podla datumu (mergeKeys)
vystup_tbl = outerjoin(nezamestnanost_tbl, inflacia_tbl, 'Keys', 'Datum', 'MergeKeys', true, 'Type', 'left');

fprintf('\nSpojenie tabuliek uspesne.\n');
% vypis vystupnej tabulky na konzolu display(table)
disp(vystup_tbl);



% ulozenie do workspace
save('data_import.mat', 'vystup_tbl');

