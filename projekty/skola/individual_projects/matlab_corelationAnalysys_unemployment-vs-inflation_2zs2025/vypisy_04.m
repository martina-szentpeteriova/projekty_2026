% vypisy_04.m
% vizualizacie: grafy, vypisy do konzoly

load('data_analyza.mat');

% ak sa nachadzame v bunke s poctom nezamestnanych
if iscell(vystup_tbl.PocetNezamestnanych) 
    % n=vyska tabulky
    n = height(vystup_tbl);
    % pocetNezam=NaN je stlpcovy vektor kde sa nam ulozia neciselne hodnoty
    % z riadka n, a stlpca 1
    pocetNezam = NaN(n, 1);
    % prechadza v nasom stlpci po riadkoch
    for i = 1:n
        % oznacia sa podla indexu
        hodnota = vystup_tbl.PocetNezamestnanych{i};
        % kontroluje ci je hodnota v bunke ciselny udaj
        if isnumeric(hodnota) && isscalar(hodnota)
            % ak ano, ulozi ju na dany index v stlpci
            pocetNezam(i) = hodnota;
        % ak nie je ciselny udaj
        elseif ischar(hodnota) || isstring(hodnota)
            % pretypuje sa najskor
            cislo = str2double(hodnota);
            % a ak po pretypovani je uz ciselnym udajom
            if ~isnan(cislo)
                % ulozi ho do danej bunky indexu riadku v nasom stlpci
                pocetNezam(i) = cislo;
            end
        end
    end
else
    % ak je to v type aky ma byt -> priamo to uklada tak ako je do tabulky
    pocetNezam = vystup_tbl.PocetNezamestnanych;
end


% ----- GRAFY -----
% figure = okno, tiledlayout = zobrazenie cez dlazdice
figure;
tiledlayout(3,2, 'TileSpacing', 'compact', 'Padding', 'compact');

% --- graf 1 – pocet nezamestnanych ---
% nextile = dalsia dlazdica grafu v okne
% plot(x,y,'farba')
% grid on = mriezka
nexttile;
fprintf('✅ Graf 1 sa vykresľuje (Počet nezamestnaných osôb) ....\n');
plot(vystup_tbl.Datum, pocetNezam, 'r');
title('Graf 1 – Počet nezamestnaných'); xlabel('Obdobie'); 
ylabel('Počet osôb'); grid on; 
% nastavenie pekneho formatu cisel
ax = gca;
ax.YAxis.Exponent = 0;      % vypne vedecky zapis
ytickformat('%,.0f');       % napr. 223,500

% --- graf 2 – inflacia medzirocna ---
nexttile;
% ak sa hodnoty ulozia zle - nebudu ciselne - graf nevykresli
% piktogramy su tam aby sa dalo pekne vidiet na vystupe ak je chyba alebo
% ak to zbehlo
if all(isnan(vystup_tbl.MedzirocnaInflacia))
    warning('⚠️ Medziročná inflácia obsahuje len NaN – graf sa nevykreslí.\n');
else
    % hold on = "podrzi" krivku na rovnakej dlazdici (neprekresli sa novou,
    % vsetko sa vykresli spolu na jednu dlazdicu)
    fprintf('✅ Graf 2 sa vykresľuje (Medziročná inflácia) ....\n');
    plot(vystup_tbl.Datum, vystup_tbl.MedzirocnaInflacia, 'b'); hold on;
    plot(vystup_tbl.Datum, vystup_tbl.movmean_medziroc, '--k');
    title('Graf 2 – Inflácia medziročná'); xlabel('Obdobie'); ylabel('%'); 
    legend({'medziročná infl', 'aproximovaná mr'}, 'Location', 'best'); grid on;
end

% --- graf 3 – inflacia medzimesacna ---
nexttile;
% ak stlpec tabulky obsahuje neciselne hodnoty nenakresli graf
if all(isnan(vystup_tbl.MedzimesacnaInflacia))
    warning('⚠️ Medzimesačná inflácia obsahuje len NaN – graf sa nevykreslí.');
else
    fprintf('✅ Graf 3 sa vykresľuje (Medzimesačná inflácia) ....\n');
    plot(vystup_tbl.Datum, vystup_tbl.MedzimesacnaInflacia, 'g'); hold on;
    plot(vystup_tbl.Datum, vystup_tbl.movmean_medzimes, '--y');
    title('Graf 3 – Inflácia medzimesačná'); xlabel('Obdobie'); ylabel('%'); 
    % legenda ({nazov 1, nazov2}, 'poloha legendy', '= mimo kriviek')
    legend({'medzimesačná infl', 'aproximovaná mm'}, 'Location', 'best'); grid on;
end

% --- graf 4 – miera nezamestnanosti ---
nexttile;
fprintf('✅ Graf 4 sa vykresľuje (Miera nezamestnanosti) ....\n');
plot(vystup_tbl.Datum, vystup_tbl.MieraNezamestnanosti, 'm'); hold on;
plot(vystup_tbl.Datum, vystup_tbl.movmean_nezam, '--k'); 
title('Graf 4 – Miera nezamestnanosti (%)'); xlabel('Obdobie'); ylabel('%'); 
legend({'skutočná','aproximovaná mn'}, 'Location', 'best'); grid on;

% --- graf 5 – phillipsova krivka ---
nexttile;
% bude platit ak logický vektor indx_valid oboch hodnot bude pravda 
% (nenulove hodnoty) tak ich vykresli
% graf zo stlpcov (nezamestnanost/inflacia)
idx_valid = ~isnan(vystup_tbl.MieraNezamestnanosti) & ~isnan(vystup_tbl.MedzirocnaInflacia);
xdata = vystup_tbl.MieraNezamestnanosti(idx_valid);
ydata = vystup_tbl.MedzirocnaInflacia(idx_valid);
scatter(xdata, ydata, 'c', 'filled'); hold on;

% aproximacia/regresia polynomom stupna 5
% p = aproximacia(x,y,stupen polynomu) - pocita koeficienty polynomu 5)
% napr. p = [a5, a4, a3, a2, a1, a0]   -> teda: a5*x^5 + a4*x^4 + ... + a0
% numel overi ci ma aspon 6 vstupov(bodov) inak by sa to nedalo robit
if numel(xdata) >= 6
    p = polyfit(xdata, ydata, 5);
    % vytvori 100 bodov rovnomerne rozlozenych medzi min(xdata) a max(xdata)
    % pouziva sa to na hladke vykreslenie polynomu (inac by bol len v 6 bodoch)
    x = linspace(min(xdata), max(xdata), 100);
    y = polyval(p, x);
    plot(x, y, 'r', 'LineWidth', 2);
end

title('Graf 5 – Phillipsova krivka'); xlabel('Nezamestnanosť (%)'); ylabel('Inflácia (%)'); 
legend({'dáta','polynóm - Phillipsova krivka'}, 'Location', 'best'); grid on;
fprintf('✅ Graf 5 sa vykresľuje (Phillipsova krivka) ....\n');

% --- vypis do konzoly ---
fprintf('✅ Vykresľuje sa výstupná tabuľka ....\n');
fprintf('\n Priemerné mesačné hodnoty:\n');
% display(tabulka)
disp(vystup_tbl)

hold off
