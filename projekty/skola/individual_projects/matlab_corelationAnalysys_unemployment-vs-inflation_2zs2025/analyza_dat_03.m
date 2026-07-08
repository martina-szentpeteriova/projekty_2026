
% analyza_dat_03.m
% analyza dat: vypocty, korelacie, movmean, aproximacie

load('data_import.mat');

% vypocet movmean (3-mesacny klzavy priemer)

% pretypovanie z cell na ciselny vektor (napr. 55x1 double)
% bezpecne pretypovanie stlpcov, ktore su povodne typu cell
stlpce_na_pretypovanie = {'MieraNezamestnanosti', 'MedzirocnaInflacia', 'MedzimesacnaInflacia'};

% od prveho stlpca po pocet stlpcov ktore chceme pretypovat
for i = 1:length(stlpce_na_pretypovanie)
    % oznacia sa (podla indexu)
    nazov = stlpce_na_pretypovanie{i};
    
    if iscell(vystup_tbl.(nazov))
        % n = pocet riadkov tabulky (vyska vystupnej tabulky - hodnoty
        % ktore pouzivame do grafov)
        n = height(vystup_tbl);
        % uklada sa do stlpcoveho vektora nenulovych hodnot (preto nazvane
        %  Nan=not a number)
        vysledok = NaN(n,1);
        
        % pohyb po riadkoch n
        for j = 1:n
            % do hodnoty sa ulozia podla indexu j do riadkov prislusneho
            % stlpca i
            hodnota = vystup_tbl.(nazov){j};
            % ak je ciselna ulozi sa normalne
            if isnumeric(hodnota) && isscalar(hodnota)
                vysledok(j) = hodnota;
            % ak je neciselnej hodnoty, najprv sa pretypuje
            elseif ischar(hodnota) || isstring(hodnota)
                cislo = str2double(hodnota);
                % po pretypovani 
                if ~isnan(cislo)
                    % vlozi hodnotu na dany index
                    vysledok(j) = cislo;
                end
            end
        end
        % do nasho stlpca vlozi vysledky movmean
        vystup_tbl.(nazov) = vysledok;  % nahrad original stlpec
    end
end

% az potom sa moze vypocitat klzavy priemer 
% (zavolanim fcie movmean(stlpec hodnot, krok pred/za, vynechat 
% neciselne hodnoty - omitting not a number))
vystup_tbl.movmean_nezam = movmean(vystup_tbl.MieraNezamestnanosti, 3, 'omitnan');
vystup_tbl.movmean_medziroc = movmean(vystup_tbl.MedzirocnaInflacia, 3, 'omitnan');
vystup_tbl.movmean_medzimes = movmean(vystup_tbl.MedzimesacnaInflacia, 3,  'omitnan');


% ulozenie do workspace
save('data_analyza.mat', 'vystup_tbl');

